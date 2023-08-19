//
//  W3TransferManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import Web3
import Web3ContractABI
import PromiseKit

public struct W3TransferManager {
    
    // MARK: - Type Aliases
    
    
    // MARK: - Internal Properties
    public init(web3: Web3) {
        self.web3 = web3
    }
    
    // MARK: - Initilizer
    private let web3: Web3!
   
    // MARK: - Private Properties
    private var walletManager = PinoWalletManager()
    private var gasInfoManager: W3GasInfoManager {
        return .init(web3: web3)
    }
    private var trxManager: W3TransactionManager {
        return .init(web3: web3)
    }
    
    // MARK: - Public Methods

    public func sendERC20TokenTo(
        recipientAddress address: String,
        amount: BigUInt,
        tokenContractAddress: String
    ) -> Promise<String> {
        

        return Promise<String>() { [self] seal in

            gasInfoManager.calculateSendERCGasFee(recipient: address, amount: amount, tokenContractAddress: tokenContractAddress)
                .then { [self] gasInfo in
                    let privateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
                    return web3.eth.getTransactionCount(address: privateKey.address, block: .latest).map { ($0, gasInfo) }
                }
                .then { [self] nonce, gasInfo in
                let myPrivateKey = try EthereumPrivateKey(
                    hexPrivateKey: walletManager.currentAccountPrivateKey
                        .string
                )
                let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, web3: web3)
                let to = try EthereumAddress(hex: address, eip55: true)
                let solInvocation = contract[ABIMethodWrite.transfer.rawValue]?(to, amount)
                let trx = try trxManager.createTransactionFor(method: .transfer, contract: solInvocation!, nonce: nonce, gasPrice: gasInfo.gasPrice.etherumQuantity, gasLimit: gasInfo.gasLimit.etherumQuantity)

                let signedTx = try trx.sign(with: myPrivateKey, chainId: 1)
                return web3.eth.sendRawTransaction(transaction: signedTx)
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
                web3.eth.gasPrice()
            }.then { [self] price in
                web3.eth.getTransactionCount(address: privateKey.address, block: .latest).map { ($0, price) }
            }.then { nonce, price in
                var tx = try EthereumTransaction(
                    nonce: nonce,
                    gasPrice: price,
                    to: EthereumAddress(hex: address, eip55: true),
                    value: enteredAmount
                )
                tx.gasLimit = 21000
                tx.transactionType = .legacy
                return try tx.sign(with: privateKey, chainId: 1).promise
            }.then { [self] tx in
                web3.eth.sendRawTransaction(transaction: tx)
            }.done { hash in
                seal.fulfill(hash.hex())
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    
}
