//
//  CompoundRepayManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/14/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class CompoundRepayManager: Web3ManagerProtocol {
	// MARK: - TypeAliases

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Private Properties

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber
	private let web3Client = Web3APIClient()
	private var asset: AssetViewModel
	private var assetAmountBigNumber: BigNumber
	private var assetAmountBigUInt: BigUInt
	private var repayMode: RepayMode
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: - Public Properties

	public var repayGasInfo: GasInfo?
	public var repayTRX: EthereumSignedTransaction?

	// MARK: - Initializers

	init(contract: DynamicContract, asset: AssetViewModel, assetAmount: String, repayMode: RepayMode) {
		self.asset = asset
		self.assetAmountBigNumber = BigNumber(numberWithDecimal: assetAmount)
		self.assetAmountBigUInt = Utilities.parseToBigUInt(assetAmount, decimals: asset.decimal)!
		self.contract = contract
		self.repayMode = repayMode
	}

	// MARK: - Internal Methods

	func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract, amount: assetAmountBigUInt,
			tokenAdd: asset.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	// MARK: - Private Methods

	private func getTokenPositionID() -> Promise<String> {
		Promise<String> { seal in
			web3Client.getTokenPositionID(
				tokenAdd: asset.id.lowercased(),
				positionType: .investment,
				protocolName: DexSystemModel.compound.type
			).sink { completed in
				switch completed {
				case .finished:
					print("Position id received successfully")
				case let .failure(error):
					print("Error getting position id:\(error)")
					seal.reject(error)
				}
			} receiveValue: { tokenPositionModel in
				seal.fulfill(tokenPositionModel.positionID.lowercased())
			}.store(in: &cancellables)
		}
	}

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in

			let hashREq = EIP712HashRequestModel(
				tokenAdd: asset.id,
				amount:
				assetAmountBigUInt.description,
				spender: contract.address!.hex(eip55: true),
				nonce: nonce.description,
				deadline: deadline.description
			)

			web3Client.getHashTypedData(eip712HashReqInfo: hashREq.eip712HashReqBody).sink { completed in
				switch completed {
				case .finished:
					print("Info received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { hashResponse in
				seal.fulfill(hashResponse.hash)
			}.store(in: &cancellables)
		}
	}

	private func getERCRepayCallData(positionID: String) -> Promise<String> {
		var repayAmount: BigUInt {
			switch repayMode {
			case .decrease:
				return assetAmountBigUInt
			case .repayMax:
				return BigNumber.maxUInt256.bigUInt
			}
		}
		return web3.getCompoundERCRepayCallData(contract: contract, cTokenAddress: positionID, amount: repayAmount)
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}

	// MARK: - Public Methods

	public func getERC20RepayData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID -> Promise<(String, String)> in
				self.fetchHash().map { (positionID, $0) }
			}.then { positionID, plainHash -> Promise<(String, String)> in
				self.signHash(plainHash: plainHash).map { (positionID, $0) }
			}.then { positionID, signiture -> Promise<(String, String, String?)> in
				self.checkAllowanceOfProvider(
					approvingToken: self.asset,
					approvingAmount: self.assetAmountBigNumber.sevenDigitFormat,
					spenderAddress: positionID,
					ownerAddress: Web3Core.Constants.compoundContractAddress
				).map {
					(positionID, signiture, $0)
				}
			}.then { positionID, signiture, allowanceData -> Promise<(String, String, String?)> in
				self.getProxyPermitTransferData(signiture: signiture).map { (positionID, $0, allowanceData) }
			}.then { positionID, permitData, allowanceData -> Promise<(String, String?, String)> in
				self.getERCRepayCallData(positionID: positionID).map { (permitData, allowanceData, $0) }
			}.then { permitData, allowanceData, repayData in
				var multiCallData: [String] = [permitData, repayData]
				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
				return self.callProxyMultiCall(data: multiCallData, value: nil)
			}.done { repayResults in
				self.repayTRX = repayResults.0
				self.repayGasInfo = repayResults.1
				seal.fulfill(repayResults)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getETHRepayData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				self.getTokenPositionID()
			}.then { positionID in
				self.web3.getCompoundETHRepayContractDetails(contractID: positionID)
			}.then { contractDetails -> Promise<(ContractDetailsModel, GasInfo)> in
				self.web3.getCompoundETHRepayGasInfo(contractDetails: contractDetails).map { (contractDetails, $0) }
			}.then { contractDetails, repayGasInfo -> Promise<(GasInfo, EthereumSignedTransaction)> in
				self.web3.getCompoundETHRepayTransaction(
					contractDetails: contractDetails,
					amount: self.assetAmountBigUInt
				).map { (repayGasInfo, $0) }
			}.done { repayGasInfo, repayTransaction in
				self.repayTRX = repayTransaction
				self.repayGasInfo = repayGasInfo
				seal.fulfill((repayTransaction, repayGasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
