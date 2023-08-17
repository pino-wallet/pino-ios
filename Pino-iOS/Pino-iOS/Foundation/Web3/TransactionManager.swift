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
        method: Web3Core.ABIMethodCall,
        params: Params...,
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity) throws -> Transaction
}

public struct TransactionManager: TransactionManagerProtocol {
    
    // MARK: - Type Aliases
    
    typealias Transaction = EthereumTransaction
    
    // MARK: - Internal Properties
    
    public var contractAddress: String
   
    // MARK: - Initilizer

    public init(contractAddress: String) {
        self.contractAddress = contractAddress
    }
    
    // MARK: - Private Properties
    private var walletManager = PinoWalletManager()
    
    func createTemporaryTransactionFor<Params: ABIEncodable>(
        method: Web3Core.ABIMethodCall,
        params: Params...,
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity) throws -> EthereumTransaction {
            
            let contract = try Web3Core.shared.getContractOfToken(address: contractAddress)
            let accountPrivateKey = try EthereumPrivateKey(
                hexPrivateKey: walletManager.currentAccountPrivateKey.string
            )
            
            let transaction = contract[method.rawValue]?(params).createTransaction(
                nonce: nonce,
                gasPrice: gasPrice,
                maxFeePerGas: nil,
                maxPriorityFeePerGas: nil,
                gasLimit: nil,
                from: accountPrivateKey.address,
                value: nil,
                accessList: [:],
                transactionType: .legacy
            )
            
            return transaction!
        }
    
}
