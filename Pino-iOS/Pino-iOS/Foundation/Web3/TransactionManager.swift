//
//  TransactionHandler.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/17/23.
//

import Foundation
import Web3
import Web3ContractABI
import PromiseKit

protocol TransactionManagerProtocol {
    /// Associated Type
    associatedtype Transaction: Codable
    
    /// Properties
    
    /// Functions
    func createTemporaryTransactionFor<Params: ABIEncodable>(
        method: Web3Core.ABIMethodWrite,
        params: Params...,
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity) throws -> Transaction
}

public struct TransactionManager {
    
    // MARK: - Type Aliases
    
    typealias Transaction = EthereumTransaction
    
    // MARK: - Internal Properties
    
    
    // MARK: - Initilizer
    
   
    // MARK: - Private Properties
    private var walletManager = PinoWalletManager()
    
    internal func createTransactionFor(
        method: Web3Core.ABIMethodWrite,
        contract: SolidityInvocation,
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity,
        gasLimit: EthereumQuantity?) throws -> EthereumTransaction {
            
            let accountPrivateKey = try EthereumPrivateKey(
                hexPrivateKey: walletManager.currentAccountPrivateKey.string
            )
            
            let transaction = contract.createTransaction(
                nonce: nonce,
                gasPrice: gasPrice,
                maxFeePerGas: nil,
                maxPriorityFeePerGas: nil,
                gasLimit: gasLimit,
                from: accountPrivateKey.address,
                value: nil,
                accessList: [:],
                transactionType: .legacy
            )
            
            return transaction!
    }
    
    
    internal func calculateGasOf(method: Web3Core.ABIMethodWrite, contract: SolidityInvocation) -> Promise<(GasInfo)> {
        Promise<(GasInfo)>() { seal in
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: self.walletManager.currentAccountPrivateKey.string)

            firstly {
                Web3Core.shared.web3.eth.gasPrice()
            }.then { gasPrice in
                Web3Core.shared.web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest).map{ ($0, gasPrice) }
            }.then { nonce, gasPrice in
                try createTransactionFor(method: method, contract: contract, nonce: nonce, gasPrice: gasPrice, gasLimit: nil).promise.map { ($0, nonce, gasPrice) }
            }.then { transaction, nonce, gasPrice in
                Web3Core.shared.web3.eth.estimateGas(call: .init(to: transaction.to!)).map{ ($0,nonce,gasPrice) }
            }.done { gasLimit, nonce, gasPrice in
                let gasInfo = GasInfo(gasPrice: gasPrice.quantity, gasLimit: gasLimit.quantity)
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
        
    }
    
}
