//
//  W3GasInfoManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import Web3
import PromiseKit
import Web3ContractABI

public struct W3GasInfoManager {
    
    // MARK: - Type Aliases
    
    
    // MARK: - Internal Properties
    public init(web3: Web3) {
        self.web3 = web3
    }
    
    // MARK: - Initilizer
    private let web3: Web3!
    private var transactionManager: W3TransactionManager {
        return .init(web3: web3)
    }
    private var gasInfoManager: W3GasInfoManager {
        return .init(web3: web3)
    }
   
    // MARK: - Private Properties
    private var walletManager = PinoWalletManager()
    
    public func calculateGasOf(method: ABIMethodWrite, contract: SolidityInvocation) -> Promise<(GasInfo)> {
        Promise<(GasInfo)>() { seal in
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: self.walletManager.currentAccountPrivateKey.string)

            firstly {
                web3.eth.gasPrice()
            }.then { gasPrice in
                web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest).map{ ($0, gasPrice) }
            }.then { nonce, gasPrice in
                try transactionManager.createTransactionFor(method: method, contract: contract, nonce: nonce, gasPrice: gasPrice, gasLimit: nil).promise.map { ($0, nonce, gasPrice) }
            }.then { transaction, nonce, gasPrice in
                web3.eth.estimateGas(call: .init(to: transaction.to!)).map{ ($0,nonce,gasPrice) }
            }.done { gasLimit, nonce, gasPrice in
                let gasInfo = GasInfo(gasPrice: gasPrice.quantity, gasLimit: gasLimit.quantity)
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
        
    }
    
    public func calculateEthGasFee() -> Promise<GasInfo> {
        Promise<GasInfo>() { seal in
            attempt(maximumRetryCount: 3) { [self] in
                web3.eth.gasPrice()
            }.done { gasPrice in
                let gasLimit = try BigUInt(Web3Core.Constants.ethGasLimit)
                let gasInfo = GasInfo(gasPrice: gasPrice.quantity, gasLimit: gasLimit)
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    public func calculateSendERCGasFee(
        recipient address: String,
        amount: BigUInt,
        tokenContractAddress: String
    ) -> Promise<GasInfo> {
        return Promise<GasInfo>() { seal in
            firstly {
                let to: EthereumAddress = try! EthereumAddress(hex: address, eip55: true)
                let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, web3: web3)
                let solInvocation = contract[ABIMethodWrite.transfer.rawValue]!(to, amount)
                return gasInfoManager.calculateGasOf(method: .transfer, contract: solInvocation)
            }.done { trxGasInfo in
                let gasInfo = GasInfo(gasPrice: trxGasInfo.gasPrice, gasLimit: trxGasInfo.gasLimit)
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
}
