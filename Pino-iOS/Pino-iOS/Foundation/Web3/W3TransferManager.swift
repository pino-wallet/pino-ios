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

protocol Web3Manager {
    var writeWeb3: Web3 { get set }
    var readWeb3: Web3 { get set }
    init(writeWeb3: Web3, readWeb3: Web3)
    var gasInfoManager: W3GasInfoManager { get }
    var trxManager: W3TransactionManager { get }
    var transferManager: W3TransferManager { get }
    var walletManager: PinoWalletManager { get }
    var userPrivateKey: EthereumPrivateKey { get }
}

extension Web3Manager {
    
    var gasInfoManager: W3GasInfoManager {
        .init(writeWeb3: writeWeb3, readWeb3: readWeb3)
    }
    
    var trxManager: W3TransactionManager {
        .init(writeWeb3: writeWeb3, readWeb3: readWeb3)
    }
    
    var transferManager: W3TransferManager {
        .init(writeWeb3: writeWeb3, readWeb3: readWeb3)
    }
    
    var walletManager: PinoWalletManager {
        PinoWalletManager()
    }

    var userPrivateKey: EthereumPrivateKey {
        try! EthereumPrivateKey(
            hexPrivateKey: walletManager.currentAccountPrivateKey
                .string
        )
    }
    
}

public struct W3TransferManager: Web3Manager {
    
    // MARK: - Internal Properties

    var writeWeb3: Web3
    var readWeb3: Web3
    
    // MARK: - Initializer

    init(writeWeb3: Web3, readWeb3: Web3) {
        self.readWeb3 = readWeb3
        self.writeWeb3 = writeWeb3
    }
	
	// MARK: - Public Methods

	public func getPermitTransferFromCallData(
		contract: DynamicContract,
		amount: BigUInt,
		tokenAdd: String,
		signiture: String,
		nonce: BigUInt,
		deadline: BigUInt
	) -> Promise<String> {
		Promise<String>() { [self] seal in

			let permitModel = Permit2Model(
				permitted: .init(token: tokenAdd.eip55Address!, amount: amount.etherumQuantity),
				nonce: nonce,
				deadline: deadline
			)

			let sigData = Data(hexString: signiture, length: 130)

			let permitTransffrom = PermitTransferFrom(permitted: permitModel, signature: sigData!)

			let solInvocation = contract[ABIMethodWrite.permitTransferFrom.rawValue]?(
				permitTransffrom
			)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			print(trx.data.hex())

			seal.fulfill(trx.data.hex())
		}
	}

	public func sendERC20TokenTo(
		recipientAddress address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, abi: .erc, web3: readWeb3)
			let to = try EthereumAddress(hex: address, eip55: true)
			let solInvocation = contract[ABIMethodWrite.transfer.rawValue]?(to, amount)

			gasInfoManager.calculateGasOf(
				method: .transfer,
				solInvoc: solInvocation!,
				contractAddress: contract.address!
			)
			.then { [self] gasInfo in
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.then { [self] nonce, gasInfo in
				let trx = try trxManager.createTransactionFor(
					contract: solInvocation!,
					nonce: nonce,
					gasPrice: gasInfo.gasPrice.etherumQuantity,
					gasLimit: gasInfo.gasLimit.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				return writeWeb3.eth.sendRawTransaction(transaction: signedTx)
			}.done { txHash in
				seal.fulfill(txHash.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func sendEtherTo(recipient address: String, amount: BigUInt) -> Promise<String> {
		let enteredAmount = EthereumQuantity(quantity: amount)
		return Promise<String>() { seal in
			let privateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
			firstly {
				readWeb3.eth.gasPrice()
			}.then { [self] price in
                readWeb3.eth.getTransactionCount(address: privateKey.address, block: .latest).map { ($0, price) }
			}.then { nonce, price in
				var tx = try EthereumTransaction(
					nonce: nonce,
					gasPrice: price,
					to: EthereumAddress(hex: address, eip55: true),
					value: enteredAmount
				)
				tx.gasLimit = 21000
				tx.transactionType = .legacy
				return try tx.sign(with: privateKey, chainId: Web3Network.chainID).promise
			}.then { [self] tx in
				writeWeb3.eth.sendRawTransaction(transaction: tx)
			}.done { hash in
				seal.fulfill(hash.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
