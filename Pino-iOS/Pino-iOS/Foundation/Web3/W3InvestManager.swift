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

public struct W3InvestManager {
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

	private var contractAddress = ""

	// MARK: - Public Methods

	public func getDaiToSDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(address: contractAddress, abi: .investMaker, web3: web3)
			let solInvocation = contract[ABIMethodWrite.daiToSDai.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	public func getSDaiToDaiCallData(amount: BigUInt, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			let contract = try Web3Core.getContractOfToken(address: contractAddress, abi: .investMaker, web3: web3)
			let solInvocation = contract[ABIMethodWrite.sDaiToDai.rawValue]?(amount, recipientAdd.eip55Address!)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}
    
    public func getDepositV2CallData(tokenAdd: String, amount: BigUInt, recipientAdd: String) -> Promise<String> {
        Promise<String>() { [self] seal in
            let contract = try Web3Core.getContractOfToken(address: contractAddress, abi: .investCompound, web3: web3)
            let solInvocation = contract[ABIMethodWrite.depositV2.rawValue]?(tokenAdd, amount, recipientAdd.eip55Address!)
            let trx = try trxManager.createTransactionFor(contract: solInvocation!)
            seal.fulfill(trx.data.hex())
        }
    }
}
