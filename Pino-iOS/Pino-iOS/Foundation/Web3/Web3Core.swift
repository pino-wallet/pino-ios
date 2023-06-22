//
//  Web3Core.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/11/23.
//

import BigInt
import Foundation
import Web3
import Web3ContractABI
import Web3PromiseKit

enum Web3Error: Error {
    case invalidSmartContractAddress
    case failedTransaction
    case insufficientBalance
}

class Web3Core {
    // MARK: - Private Properties

    private init() {}
    private let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
    private let walletManager = PinoWalletManager()

    typealias CustomAssetInfo = [AssetInfo: String]
    typealias ERC20TransactionInfoType = [ERC20TransactionInfo: EthereumQuantity]
    typealias EthGasFeeInfo = (fee:BigNumber,feeInDollar:BigNumber)

    // MARK: - Public Properties

    public static var shared = Web3Core()
    public enum AssetInfo: String {
        case decimal = "decimals"
        case balance = "balanceOf"
        case name = "name"
        case symbol = "symbol"
    }

    public enum ERC20TransactionInfo: String {
        case nonce
        case gasPrice
        case estimate
        case gasLimit
    }

    // MARK: - Public Methods

    public func getCustomAssetInfo(contractAddress: String) throws -> Promise<CustomAssetInfo> {
        var assetInfo: CustomAssetInfo = [:]

        return Promise<CustomAssetInfo>() { seal in
            let _ = firstly {
                try web3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
            }.then { conctractCode in
                if conctractCode.hex() == Constants.eoaCode {
                    // In this case the smart contract belongs to an EOA
                    seal.reject(Web3Error.invalidSmartContractAddress)
                }
                return try self.getInfo(address: contractAddress, info: .decimal)
            }.then { decimalValue in
                if String(describing: decimalValue[.emptyString]) == "0" {
                    seal.reject(Web3Error.invalidSmartContractAddress)
                }
                assetInfo[AssetInfo.decimal] = "\(decimalValue[String.emptyString]!)"
                return try self.getInfo(address: contractAddress, info: .name).compactMap { nameValue in
                    nameValue[String.emptyString] as? String
                }
            }.then { nameValue in
                assetInfo.updateValue(nameValue, forKey: AssetInfo.name)
                return try self.getInfo(address: contractAddress, info: .balance).compactMap { balanceValue in
                    balanceValue[String.emptyString] as? BigUInt
                }
            }.then { balance in
                assetInfo.updateValue("\(balance)", forKey: AssetInfo.balance)
                return try self.getInfo(address: contractAddress, info: .symbol).compactMap { symbolValue in
                    symbolValue[String.emptyString] as? String
                }
            }.done { symbol in
                assetInfo.updateValue(symbol, forKey: AssetInfo.symbol)
                seal.fulfill(assetInfo)
            }
        }
    }

    public func calculateEthGasFee(ethPrice: BigNumber) -> Promise<EthGasFeeInfo> {
        Promise<EthGasFeeInfo>() { seal in
            firstly {
                web3.eth.gasPrice()
            }.done { gasPrice in
                let gasLimit = BigNumber(number: Constants.ethGasLimit, decimal: 0)
                let gasPriceBigNum = BigNumber(number: "\(gasPrice.quantity)", decimal: 0)
                let fee = BigNumber(number: gasLimit * gasPriceBigNum, decimal: 18)
                let feeInDollar = fee * ethPrice
                seal.fulfill((fee,feeInDollar))
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    public func calculateERC20TokenFee(
        address: String,
        amount: BigUInt,
        tokenContractAddress: String
    ) throws -> Promise<(EthereumQuantity, ERC20TransactionInfoType)> {
        Promise<(EthereumQuantity, ERC20TransactionInfoType)>() { [self] seal in

            let to = try EthereumAddress(hex: address, eip55: true)
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: self.walletManager.currentAccountPrivateKey.string)
            let contract = try getContractOfToken(address: tokenContractAddress)
            var transactionInfo: ERC20TransactionInfoType = [:]
            // Send some tokens to another address (locally signing the transaction)

            firstly {
                web3.eth.gasPrice()
            }.map { gasPrice in
                transactionInfo.updateValue(gasPrice, forKey: .gasPrice)
            }.then { [self] in
                web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest)
            }.map { nonce in
                transactionInfo.updateValue(nonce, forKey: .nonce)
            }.then { [self] () -> Promise<EthereumQuantity> in
                let transaction = contract["transfer"]?(to, amount).createTransaction(
                    nonce: transactionInfo[.nonce],
                    gasPrice: transactionInfo[.gasPrice],
                    maxFeePerGas: nil,
                    maxPriorityFeePerGas: nil,
                    gasLimit: nil,
                    from: myPrivateKey.address,
                    value: nil,
                    accessList: [:],
                    transactionType: .legacy
                )
                return web3.eth.estimateGas(call: .init(from: transaction?.from, to: (transaction?.to)!, gas: nil, gasPrice: transactionInfo[.gasPrice], value: nil, data: transaction!.data))
            }.done { gaslimit in
                print(gaslimit)
                transactionInfo.updateValue(gaslimit, forKey: .gasLimit)
                let estimate = try EthereumQuantity((gaslimit.quantity * BigUInt(110)) / BigUInt(100))
                let caclulated = estimate.quantity * transactionInfo[.gasPrice]!.quantity
                seal.fulfill((EthereumQuantity(quantity: caclulated),transactionInfo))
            }.catch { error in
                print(error)
                seal.reject(error)
            }
        }
    }

    public func sendEtherTo(address: String, amount: BigUInt) throws -> Promise<String> {
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

    public func sendERC20TokenTo(
        address: String,
        amount: BigUInt,
        tokenContractAddress: String
    ) throws -> Promise<String> {
        Promise<String>() { [self] seal in

            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
            let contract = try getContractOfToken(address: tokenContractAddress)
            let to = try EthereumAddress(hex: address, eip55: true)
            
            try calculateERC20TokenFee(address: address, amount: amount, tokenContractAddress: tokenContractAddress)
                .then { [self] estimate, transactionInfo -> Promise<EthereumData> in

                    guard let transaction = contract["transfer"]?(to, amount).createTransaction(
                        nonce: transactionInfo[.nonce],
                        gasPrice: transactionInfo[.gasPrice],
                        maxFeePerGas: nil,
                        maxPriorityFeePerGas: nil,
                        gasLimit: try! .init(transactionInfo[.gasLimit]!.quantity * BigUInt(110) / BigUInt(100)),
                        from: myPrivateKey.address,
                        value: 0,
                        accessList: [:],
                        transactionType: .legacy
                    ) else {
                        seal.reject(Web3Error.failedTransaction)
                        throw Web3Error.failedTransaction
                    }

                    let signedTx = try transaction.sign(with: myPrivateKey, chainId: 1)

                    return web3.eth.sendRawTransaction(transaction: signedTx)

                }.done { txHash in
                    seal.fulfill(txHash.hex())
                }.catch { error in
                    seal.reject(error)
                }
        }
    }

    // MARK: - Private Methods

    private func getInfo(address: String, info: AssetInfo) throws -> Promise<[String: Any]> {
        let contractAddress = try! EthereumAddress(hex: address, eip55: true)
        let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
        let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)

        return try contract[info.rawValue]!(EthereumAddress(hex: address, eip55: true)).call()
    }

    private func getContractOfToken(address tokenContractAddress: String) throws -> DynamicContract {
        let contractAddress = try EthereumAddress(
            hex: tokenContractAddress,
            eip55: false
        )
        let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
        // You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
        let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
        return contract
    }
}

extension Web3Core {
    enum Constants {
        static let ethGasLimit = "21000"
        static let eoaCode = "0x"
    }
}
