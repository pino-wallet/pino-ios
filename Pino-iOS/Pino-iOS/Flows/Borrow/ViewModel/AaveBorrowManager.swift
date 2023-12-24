//
//  AaveBorrowManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/2/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class AaveBorrowManager: Web3ManagerProtocol {
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

	public var borrowGasInfo: GasInfo?
	public var borrowTRX: EthereumSignedTransaction?

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

	private func getERC20BorrowContractDetails() -> Promise<ContractDetailsModel> {
		web3.getAaveERCBorrowContractDetails(
			tokenID: asset.id,
			amount: assetAmountBigUInt,
			userAddress: walletManager.currentAccount.eip55Address
		)
	}

	// MARK: - Public Methods

	public func getERC20BorrowData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getERC20BorrowContractDetails()
			}.then { contractDetails -> Promise<(ContractDetailsModel, GasInfo)> in
				self.web3.getAaveERCBorrowGasInfo(contractDetails: contractDetails).map { (contractDetails, $0) }
			}.then { contractDetails, gasInfo -> TrxWithGasInfo in
				self.web3.getAaveERCBorrowTransaction(contractDetails: contractDetails).map { ($0, gasInfo) }
			}.done { signedTx, gasInfo in
				self.borrowTRX = signedTx
				self.borrowGasInfo = gasInfo
				seal.fulfill((signedTx, gasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
