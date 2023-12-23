//
//  W3CompoundRepayManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/13/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3CompoundRepayManager: Web3HelperProtocol {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func getRepayERCCallData(
		contract: DynamicContract,
		cTokenAddress: String,
		amount: BigUInt
	) -> Promise<String> {
		Promise<String> { seal in
			let solInvocation = contract[ABIMethodWrite.repayV2.rawValue]?(
				cTokenAddress.eip55Address!,
				amount,
				walletManager.currentAccount.eip55Address.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getRepayETHCallData(
		contractID: String
	) -> Promise<String> {
		Promise<String> { seal in
			let contract = try! Web3Core.getContractOfToken(
				address: contractID,
				abi: .borrowCTokenCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.repayBorrow.rawValue]?()
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getRepayETHContractDetails(
		contractID: String
	) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try! Web3Core.getContractOfToken(
				address: contractID,
				abi: .borrowCTokenCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.repayBorrow.rawValue]?()
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
		}
	}

	public func getRepayETHGasInfo(contractDetails: ContractDetailsModel, method: ABIMethodWrite) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			gasInfoManager.calculateGasOf(
				method: method,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			).done { gasInfo in
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getRepayETHTransaction(
		contractDetails: ContractDetailsModel,
		amount: BigUInt,
		method: ABIMethodWrite
	) -> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in
			gasInfoManager.calculateGasOf(
				method: method,
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
					gasInfo: gasInfo,
					value: amount.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				seal.fulfill(signedTx)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getRepayMaxETHContractDetails() -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try! Web3Core.getContractOfToken(
				address: Web3Core.Constants.maxiMillionContractAddress,
				abi: .maxiMillion,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.repayBehalf.rawValue]?(
				walletManager.currentAccount.eip55Address
					.eip55Address!
			)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
		}
	}
}
