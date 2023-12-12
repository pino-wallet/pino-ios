//
//  W3CompoundBorrowManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/10/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3CompoundBorrowManager: Web3HelperProtocol {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func getContractDetails(contractAddress: String, amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: contractAddress,
				abi: .borrowCTokenCompound,
				web3: readWeb3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCTokenBorrowGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			gasInfoManager.calculateGasOf(
				method: .borrow,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			).done { gasInfo in
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getCTokenBorrowTransaction(
		contractDetails: ContractDetailsModel
	) -> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in

			gasInfoManager.calculateGasOf(
				method: .borrow,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			)
			.then { [self] gasInfo in
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.done { [self] nonce, gasInfo in

				let trx = try trxManager.createTransactionFor(
					contract: contractDetails.solInvocation,
					nonce: nonce,
					gasInfo: gasInfo
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				seal.fulfill(signedTx)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
