//
//  AaveRepayManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/3/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class AaveRepayManager: Web3ManagerProtocol {
	// MARK: - TypeAliases

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Private Properties

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber
	private let web3Client = Web3APIClient()
	private var asset: AssetViewModel
	private var assetAmountBigNumber: BigNumber
	private var assetAmountBigUInt: BigUInt

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()
	internal var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var repayGasInfo: GasInfo?
	public var repayTRX: EthereumSignedTransaction?

	// MARK: - Initializers

	init(contract: DynamicContract, asset: AssetViewModel, assetAmount: String) {
		if asset.isEth {
			self.asset = (GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
		} else {
			self.asset = asset
		}
		self.assetAmountBigNumber = BigNumber(numberWithDecimal: assetAmount)
		self.assetAmountBigUInt = Utilities.parseToBigUInt(assetAmount, decimals: asset.decimal)!
		self.contract = contract
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

	private func getERCRepayCallData() -> Promise<String> {
		web3.getAaveRepayERCCallData(contract: contract, tokenAddress: asset.id, amount: assetAmountBigUInt)
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
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<(String, String?)> in
				self.checkAllowanceOfProvider(
					approvingToken: self.asset,
					approvingAmount: self.assetAmountBigNumber.sevenDigitFormat,
					spenderAddress: Web3Core.Constants.aavePoolERCContractAddress
				).map {
					(signiture, $0)
				}
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { permitData, allowanceData -> Promise<(String, String, String?)> in
				self.getERCRepayCallData().map { ($0, permitData, allowanceData) }
			}.then { repayData, permitData, allowanceData in
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
}
