//
//  AaveDepositManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/10/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class AaveDepositManager: Web3ManagerProtocol {
	// MARK: - Private Properties

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber
	private let web3Client = Web3APIClient()
	private var selectedToken: AssetViewModel
	private var depositAmount: String
	private var assetAmountBigUInt: BigUInt
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: - Public Properties

	public var depositGasInfo: GasInfo?
	public var depositTRX: EthereumSignedTransaction?

	// MARK: - Initializers

	init(contract: DynamicContract, selectedToken: AssetViewModel, depositAmount: String) {
		if selectedToken.isEth {
			self.selectedToken = GlobalVariables.shared.manageAssetsList!.first(where: { $0.isWEth })!
		} else {
			self.selectedToken = selectedToken
		}
		self.depositAmount = depositAmount
		self.assetAmountBigUInt = Utilities.parseToBigUInt(depositAmount, decimals: selectedToken.decimal)!
		self.contract = contract
	}

	// MARK: - Public Methods

	public func getDepositInfo() -> Promise<[GasInfo]> {
		if selectedToken.isEth {
			return getETHDepositInfo()
		} else {
			return getERC20DepositInfo()
		}
	}

	// MARK: - Internal Methods

	internal func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract, amount: assetAmountBigUInt,
			tokenAdd: selectedToken.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	// MARK: - Private Methods

	public func getERC20DepositInfo() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<(String, String?)> in
				self.checkAllowanceOfProvider(
					approvingToken: self.selectedToken,
					approvingAmount: self.depositAmount,
					spenderAddress: Web3Core.Constants.aavePoolERCContractAddress
				).map {
					(signiture, $0)
				}
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { permitData, allowanceData -> Promise<(String, String, String?)> in
				self.getAaveDespositV3ERCCallData().map { ($0, permitData, allowanceData) }
			}.then { depositData, permitData, allowanceData in
				var multiCallData: [String] = [permitData, depositData]
				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
				return self.callProxyMultiCall(data: multiCallData, value: nil)
			}.done { depositResults in
				self.depositTRX = depositResults.0
				self.depositGasInfo = depositResults.1
				seal.fulfill([depositResults.1])
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getETHDepositInfo() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
			// Implement later
		}
	}

	private func checkIfAssetUsedAsCollateral() -> Promise<Bool> {
		web3.checkIfAssetUsedAsCollateral(assetAddress: selectedToken.id)
	}

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in

			let hashREq = EIP712HashRequestModel(
				tokenAdd: selectedToken.id,
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

	private func getAaveDespositV3ERCCallData() -> Promise<String> {
		web3.getAaveDespositV3ERCCallData(
			contract: contract,
			assetAddress: selectedToken.id,
			amount: assetAmountBigUInt,
			userAddress: walletManager.currentAccount.eip55Address
		)
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}
}
