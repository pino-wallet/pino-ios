//
//  Web3InvestManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 10/9/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3InvestManager: Web3Manager {
	
    // MARK: - Internal Properties
    
    var writeWeb3: Web3
    var readWeb3: Web3
    
    // MARK: - Initializer
    
    init(writeWeb3: Web3, readWeb3: Web3) {
        self.readWeb3 = readWeb3
        self.writeWeb3 = writeWeb3
    }

	// MARK: - Public Methods

	public func getInvestProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.investContractAddress,
			abi: .investMaker,
			web3: readWeb3
		)
	}

	public func getCompoundProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.compoundContractAddress,
			abi: .investCompound,
			web3: readWeb3
		)
	}

	public func getDaiToSDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.investContractAddress,
				abi: .investMaker,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.daiToSDai.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getSDaiToDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.investContractAddress,
				abi: .investMaker,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.sDaiToDai.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getDepositV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundContractAddress,
				abi: .investCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.depositV2.rawValue]?(
				amount,
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getDepositETHV2CallData(recipientAdd: String, proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundContractAddress,
				abi: .investCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.depositETHV2.rawValue]?(recipientAdd.eip55Address!, proxyFee)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getDepositWETHV2CallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundContractAddress,
				abi: .investCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.depositWETHV2.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWithdrawV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundContractAddress,
				abi: .investCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.withdrawV2.rawValue]?(
				amount,
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWithdrawETHV2CallData(recipientAdd: String, amount: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundContractAddress,
				abi: .investCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.withdrawETHV2.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getWithdrawWETHV2CallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.compoundContractAddress,
				abi: .investCompound,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.withdrawWETHV2.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}
}
