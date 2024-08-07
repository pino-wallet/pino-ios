//
//  AaveWithdrawManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/25/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class AaveWithdrawManager: Web3ManagerProtocol {
	// MARK: - TypeAliases

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Private Properties

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber
	private let web3Client = Web3APIClient()
	private var asset: AssetViewModel
	private var positionAsset: AssetViewModel
	private var assetAmountBigNumber: BigNumber
	private var assetAmountBigUInt: BigUInt

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()
	internal var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var withdrawGasInfo: GasInfo?
	public var withdrawTRX: EthereumSignedTransaction?

	// MARK: - Initializers

	init(contract: DynamicContract, asset: AssetViewModel, assetAmount: String, positionAsset: AssetViewModel) {
		if asset.isEth {
			self.asset = (GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
		} else {
			self.asset = asset
		}
		self.positionAsset = positionAsset
		self.assetAmountBigNumber = BigNumber(numberWithDecimal: assetAmount)!
		self.assetAmountBigUInt = Utilities.parseToBigUInt(assetAmount, decimals: asset.decimal)!
		self.contract = contract
	}

	// MARK: - Internal Methods

	func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract, amount: assetAmountBigUInt,
			tokenAdd: positionAsset.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	// MARK: - Private Methods

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in

			let hashREq = EIP712HashRequestModel(
				tokenAdd: positionAsset.id,
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

	private func getERCWithdrawCallData() -> Promise<String> {
		web3.getAaveWithdrawERCCallData(
			contract: contract,
			tokenAddress: asset.id,
			amount: assetAmountBigUInt,
			userAddress: walletManager.currentAccount.eip55Address
		)
	}

	private func getETHWithdrawCallData() -> Promise<String> {
		web3.getAaveWithdrawERCCallData(
			contract: contract,
			tokenAddress: asset.id,
			amount: assetAmountBigUInt,
			userAddress: (contract.address?.hex(eip55: true))!
		)
	}

	private func getERCWithdrawMaxContractDetails() -> Promise<ContractDetailsModel> {
		web3.getAaveWithdrawMaxERCContractDetails(tokenAddress: asset.id)
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}

	// MARK: - Public Methods

	public func getWithdrawInfo() -> TrxWithGasInfo {
		if asset.isEth {
			return getETHWithdrawData()
		} else {
			return getERC20WithdrawData()
		}
	}

	public func getWithdrawMaxInfo() -> TrxWithGasInfo {
		if asset.isEth {
			return getETHWithdrawData()
		} else {
			return getERC20WithdrawMaxData()
		}
	}

	public func getERC20WithdrawData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<(String, String?)> in
				self.checkAllowanceOfProvider(
					approvingToken: self.positionAsset,
					approvingAmount: self.assetAmountBigNumber.decimalString,
					spenderAddress: Web3Core.Constants.aavePoolERCContractAddress
				).map {
					(signiture, $0)
				}
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { permitData, allowanceData -> Promise<(String, String, String?)> in
				self.getERCWithdrawCallData().map {
					($0, permitData, allowanceData)
				}
			}.then { withdrawData, permitData, allowanceData in
				var multiCallData: [String] = [permitData, withdrawData]
				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
				return self.callProxyMultiCall(data: multiCallData, value: nil)
			}.done { depositResults in
				self.withdrawTRX = depositResults.0
				self.withdrawGasInfo = depositResults.1
				seal.fulfill(depositResults)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getERC20WithdrawMaxData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getERCWithdrawMaxContractDetails()
			}.then { contractDetails -> Promise<(ContractDetailsModel, GasInfo)> in
				self.web3.getAaveWithdrawMaxERCGasInfo(contractDetails: contractDetails).map { (contractDetails, $0) }
			}.then { contractDetails, gasInfo -> TrxWithGasInfo in
				self.web3.getAaveWithdrawMAXERCTransaction(contractDetails: contractDetails).map { ($0, gasInfo) }
			}.done { signedTx, gasInfo in
				self.withdrawTRX = signedTx
				self.withdrawGasInfo = gasInfo
				seal.fulfill((signedTx, gasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	#warning("maybe we use it later")
	public func getETHWithdrawData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			//			firstly {
			//				fetchHash()
			//			}.then { plainHash in
			//				self.signHash(plainHash: plainHash)
			//			}.then { signiture in
			//				self.checkAllowanceOfProvider(
			//					approvingToken: self.positionAsset,
			//					approvingAmount: self.assetAmountBigNumber.sevenDigitFormat,
			//					spenderAddress: Web3Core.Constants.aavePoolERCContractAddress
			//				).map {
			//					(signiture, $0)
			//				}
			//			}.then { signiture, allowanceData -> Promise<(String, String?)> in
			//				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			//			}.then { permitData, allowanceData -> Promise<(String, String, String?)> in
			//				self.getETHWithdrawCallData().map {
			//					($0, permitData, allowanceData)
			//				}
			//			}.then { withdrawData, permitData, allowanceData -> Promise<(String, String, String, String?)> in
			//				self.web3.getAaveUnwrapWETHCallData(contract: self.contract)
			//					.map { ($0, withdrawData, permitData, allowanceData) }
			//			}.then { unwrapData, withdrawData, permitData, allowanceData in
			//				var multiCallData: [String] = [permitData, withdrawData, unwrapData]
			//				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
			//				return self.callProxyMultiCall(data: multiCallData, value: nil)
			//			}.done { depositResults in
			//				self.withdrawTRX = depositResults.0
			//				self.withdrawGasInfo = depositResults.1
			//				seal.fulfill(depositResults)
			//			}.catch { error in
			//				seal.reject(error)
			//			}
		}
	}
}
