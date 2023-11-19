//
//  W3TransferManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3ApproveManager: Web3Manager {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func approveContract(contractDetails: ContractDetailsModel) -> Promise<String> {
		Promise<String> { seal in
			getApproveTransaction(contractDetails: contractDetails).then { signedTrx in
				writeWeb3.eth.sendRawTransaction(transaction: signedTrx)
			}
			.done { trxHash in
				seal.fulfill(trxHash.hex())
			}.catch { error in
				print(error)
				seal.reject(error)
			}
		}
	}

	public func getApproveCallData(contractAdd: String, amount: BigUInt, spender: String) -> Promise<String> {
		Promise<String> { seal in

			let contract = try Web3Core.getContractOfToken(address: contractAdd, abi: .swap, web3: readWeb3)
			let solInvocation = contract[ABIMethodWrite.approve.rawValue]?(spender, amount)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getApproveProxyCallData(contract: DynamicContract, tokenAdd: String, spender: String) -> Promise<String> {
		Promise<String> { seal in

			let solInvocation = contract[ABIMethodWrite.approveToken.rawValue]?(
				tokenAdd.eip55Address!,
				[spender.eip55Address!]
			)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getApproveContractDetails(
		address: String,
		amount: BigUInt,
		spender: String
	) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(address: address, abi: .erc, web3: readWeb3)
			let solInvocation = contract[ABIMethodWrite.approve.rawValue]?(spender.eip55Address!, amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
		}
	}

	public func getApproveGasInfo(
		contractDetails: ContractDetailsModel
	) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			gasInfoManager.calculateGasOf(
				method: .approve,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			).done { gasInfo in
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	// MARK: - Private Properties

	private func getApproveTransaction(
		contractDetails: ContractDetailsModel
	) -> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in

			gasInfoManager.calculateGasOf(
				method: .approve,
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
					gasPrice: gasInfo.gasPrice.etherumQuantity,
					gasLimit: gasInfo.increasedGasLimit.bigUInt.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				seal.fulfill(signedTx)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
