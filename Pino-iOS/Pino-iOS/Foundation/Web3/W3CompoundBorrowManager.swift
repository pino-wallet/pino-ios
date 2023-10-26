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

public struct W3CompoundBorrowManager {
	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var walletManager = PinoWalletManager()
	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var trxManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var userPrivateKey: EthereumPrivateKey {
		try! EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey
				.string
		)
	}

	// MARK: - Public Methods

	public func borrowCToken(contractDetails: ContractDetailsModel) -> Promise<String> {
		Promise<String> { seal in
			getCTokenBorrowTransaction(contractDetails: contractDetails).then { signedtransaction in
				web3.eth.sendRawTransaction(transaction: signedtransaction)
			}.done { trxHash in
				seal.fulfill(trxHash.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getCAaveContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCAaveContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCDaiContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCDaiContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCEthContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCEthContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCUniContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCUniContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCCompContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCCompContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCLinkContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCLinkContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCUsdcContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCUsdcContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCUsdtContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCUsdtContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
			)
			let solInvolcation = contract[ABIMethodWrite.borrow.rawValue]?(amount)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvolcation!))
		}
	}

	public func getCWbtcContractDetails(amount: BigUInt) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundCWbtcContractAddress,
				abi: .borrowCTokenCompound,
				web3: web3
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

	// MARK: - Private Properties

	private func getCTokenBorrowTransaction(
		contractDetails: ContractDetailsModel
	) -> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in

			gasInfoManager.calculateGasOf(
				method: .borrow,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			)
			.then { [self] gasInfo in
				web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.done { [self] nonce, gasInfo in

				let trx = try trxManager.createTransactionFor(
					contract: contractDetails.solInvocation,
					nonce: nonce,
					gasPrice: gasInfo.gasPrice.etherumQuantity,
					gasLimit: gasInfo.increasedGasLimit.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Core.chainID)
				seal.fulfill(signedTx)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
