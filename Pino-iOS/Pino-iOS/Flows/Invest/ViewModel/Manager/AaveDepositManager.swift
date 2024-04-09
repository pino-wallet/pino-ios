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
	private var trxNonce: EthereumQuantity!
	private let web3Client = Web3APIClient()
	private var selectedToken: AssetViewModel
	private var depositAmount: String
	private var assetAmountBigUInt: BigUInt

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()
	internal var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var depositGasInfo: GasInfo?
	public var depositTRX: EthereumSignedTransaction?
	public var collateralCheckGasInfo: GasInfo?
	public var collateralCheckTRX: EthereumSignedTransaction?

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

	public func getIncreaseDepositInfo() -> Promise<[GasInfo]> {
		if selectedToken.isEth {
			return getETHDepositInfo()
		} else {
			return getERC20IncreaseDepositInfo()
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
				).map { (signiture, $0) }
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { permitData, allowanceData -> Promise<(String, String, String?)> in
				self.getAaveDespositV3ERCCallData().map { ($0, permitData, allowanceData) }
			}.then { depositData, permitData, allowanceData in
				self.web3.getNonce().map { ($0, depositData, permitData, allowanceData) }
			}.then { trxNonce, depositData, permitData, allowanceData in
				self.trxNonce = trxNonce
				var multiCallData: [String] = [permitData, depositData]
				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
				return self.callProxyMultiCall(data: multiCallData, value: nil, trxNonce: trxNonce)
			}.then { depositResult in
				self.getDisableCollateralInfo().map { (depositResult, $0) }
			}.done { [self] depositResults, collateralCheckGas in
				depositTRX = depositResults.0
				depositGasInfo = depositResults.1
				seal.fulfill([depositGasInfo!, collateralCheckGas])
			}.catch { error in
				print("W3 Error: getting Aave deposit info: \(error)")
				seal.reject(error)
			}
		}
	}

	public func getERC20IncreaseDepositInfo() -> Promise<[GasInfo]> {
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
				).map { (signiture, $0) }
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
				print("W3 Error: getting Aave deposit info: \(error)")
				seal.reject(error)
			}
		}
	}

	public func getETHDepositInfo() -> Promise<[GasInfo]> {
		Promise<[GasInfo]> { seal in
			// Implement later
		}
	}

	private func getDisableCollateralInfo() -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			firstly {
				self.web3.getDisableCollateralCallData(tokenAddress: selectedToken.id)
			}.then { trxCallData in
				let collateralCheckContract = try self.web3.getDisableCollateralProxyContract()
				let collateralCheckNonce = EthereumQuantity(quantity: self.trxNonce.quantity + 1)
				return self.web3.getTransactionCallData(
					contractAddress: collateralCheckContract.address!.hex(eip55: true),
					trxCallData: trxCallData,
					nonce: collateralCheckNonce,
					gasLimit: 115_000
				)
			}.done { result in
				self.collateralCheckTRX = result.0
				self.collateralCheckGasInfo = result.1
				seal.fulfill(self.collateralCheckGasInfo!)
			}.catch { error in
				print("W3 Error: getting Aave disable collateral info: \(error)")
				seal.reject(error)
			}
		}
	}

	private func checkCollateral() -> Promise<Bool> {
		Promise<Bool> { seal in
			firstly {
				self.web3.checkIfAssetUsedAsCollateral(assetAddress: selectedToken.id)
			}.done { isCollateral in
				seal.fulfill(isCollateral)
			}.catch { error in
				print("W3 Error: getting Aave check collateral info: \(error)")
				seal.reject(error)
			}
		}
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
					print("User hash received successfully")
				case let .failure(error):
					print("Error: getting user hash: \(error)")
					seal.reject(error)
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

	private func callProxyMultiCall(
		data: [String],
		value: BigUInt?,
		trxNonce: EthereumQuantity? = nil
	) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt,
			nonce: trxNonce
		)
	}
}
