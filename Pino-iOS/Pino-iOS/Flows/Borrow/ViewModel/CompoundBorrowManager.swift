//
//  CompoundBorrowManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/12/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class CompoundBorrowManager: Web3ManagerProtocol {
	// MARK: - TypeAliases

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Private Properties

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber
	private let web3Client = Web3APIClient()
	private var asset: AssetViewModel
	private var assetAmountBigNumber: BigNumber
	private var assetAmountBigUInt: BigUInt
    private var ethToken: AssetViewModel {
        (GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth }))!
    }
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: - Public Properties

	public var borrowGasInfo: GasInfo?
	public var borrowTRX: EthereumSignedTransaction?

	// MARK: - Initializers

	init(contract: DynamicContract, asset: AssetViewModel, assetAmount: String) {
        self.asset = asset
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

	private func getBorrowContractDetails(contractID: String) -> Promise<ContractDetailsModel> {
		web3.getCompoundBorrowCTokenContractDetails(contractID: contractID, amount: assetAmountBigUInt)
	}

	// MARK: - Public Methods

	public func getBorrowData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionTokenId in
				self.getBorrowContractDetails(contractID: positionTokenId)
			}.then { borrowContractDetails -> Promise<(ContractDetailsModel, GasInfo)> in
				self.web3.getCompoundBorrowCTokenGasInfo(contractDetails: borrowContractDetails)
					.map { (borrowContractDetails, $0) }
			}.then { borrowContractDetails, borrowGasInfo -> Promise<(GasInfo, EthereumSignedTransaction)> in
				self.web3.getCompoundBorrowTransaction(contractDetails: borrowContractDetails)
					.map { (borrowGasInfo, $0) }
			}.done { borrowGasInfo, borrowTRX in
				self.borrowTRX = borrowTRX
				self.borrowGasInfo = borrowGasInfo
				seal.fulfill((borrowTRX, borrowGasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
