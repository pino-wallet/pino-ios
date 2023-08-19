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

public struct GasInfo {
    
    let gasPrice: BigUInt
    let gasLimit: BigUInt
    
    var increasedGasLimit: BigUInt {
        try! EthereumQuantity((gasLimit * BigUInt(110)) / BigUInt(100)).quantity
    }
    
    var fee: BigUInt {
        increasedGasLimit * gasPrice
    }
    
    var feeInDollar: BigNumber{
        let eth = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
        let fee = BigNumber(unSignedNumber: fee, decimal: 18)
        return fee * eth!.price
    }
    
}

public enum ABIMethodCall: String {
    case decimal = "decimals"
    case balance = "balanceOf"
    case name
    case symbol
    case allowance
    case approve
}

public enum ABIMethodWrite: String {
    case approve
    case transfer
}

public class Web3Core {
    
    // MARK: - Private Properties

	private init() {}
    private var web3: Web3 {
        if let testURL = AboutPinoView.web3URL {
            return Web3(rpcURL: testURL)
        } else {
            return Web3(rpcURL: "https://rpc.ankr.com/eth")
        }
    }
    private var trxManager: W3TransferManager {
        .init(web3: web3)
    }
    private var gasInfoManager: W3GasInfoManager {
        .init(web3: web3)
    }
    private var transferManager: W3TransferManager {
        .init(web3: web3)
    }
    
    private let walletManager = PinoWalletManager()

    // MARK: - Yypealias

	public typealias CustomAssetInfo = [ABIMethodCall: String]

	// MARK: - Public Properties

	public static var shared = Web3Core()


	// MARK: - Public Methods

    public func getAllowanceOf(contractAddress: String, spenderAddress: String, ownerAddress:String) throws -> Promise<BigUInt> {
        
        let contractAddress = try EthereumAddress(hex: contractAddress, eip55: true)
        let ownerAddress = try EthereumAddress(hex: ownerAddress, eip55: true)
        let spenderAddress = try EthereumAddress(hex: spenderAddress, eip55: true)

        return try callABIMethod(method: .allowance, contractAddress: contractAddress, params: ownerAddress,spenderAddress)
    }
    
    public func approve() {
        // Proccess is like Send
//        guard let transaction = contract["transfer"]?(to, amount).createTransaction(
//            nonce: transactionInfo[.nonce],
//            gasPrice: transactionInfo[.gasPrice],
//            maxFeePerGas: nil,
//            maxPriorityFeePerGas: nil,
//            gasLimit: try .init(transactionInfo[.gasLimit]!.quantity * BigUInt(110) / BigUInt(100)),
//            from: myPrivateKey.address,
//            value: 0,
//            accessList: [:],
//            transactionType: .legacy
//        ) else {
//            throw Web3Error.failedTransaction
//        }
//
//        let signedTx = try transaction.sign(with: myPrivateKey, chainId: 1)
    }
    
	public func getCustomAssetInfo(contractAddress: String) -> Promise<CustomAssetInfo> {
		var assetInfo: CustomAssetInfo = [:]

		return Promise<CustomAssetInfo>() { seal in
			let _ = firstly {
				try web3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
			}.then { conctractCode in
				if conctractCode.hex() == Constants.eoaCode {
					// In this case the smart contract belongs to an EOA
					throw Web3Error.invalidSmartContractAddress
				}
				return try self.getInfo(address: contractAddress, info: .decimal)
			}.then { decimalValue in
				if String(describing: decimalValue[.emptyString]) == "0" {
					throw Web3Error.invalidSmartContractAddress
				}
				assetInfo[ABIMethodCall.decimal] = "\(decimalValue[String.emptyString]!)"
				return try self.getInfo(address: contractAddress, info: .name).compactMap { nameValue in
					nameValue[String.emptyString] as? String
				}
			}.then { [self] nameValue -> Promise<[String: Any]> in
				assetInfo.updateValue(nameValue, forKey: ABIMethodCall.name)
				let contractAddress = try EthereumAddress(hex: contractAddress, eip55: true)
				let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
				return try contract
					.balanceOf(address: EthereumAddress(hex: walletManager.currentAccount.eip55Address, eip55: true))
					.call()
			}.map { balanceValue in
				balanceValue["_balance"] as! BigUInt
			}.then { balance in
				assetInfo.updateValue("\(balance)", forKey: ABIMethodCall.balance)
				return try self.getInfo(address: contractAddress, info: .symbol).compactMap { symbolValue in
					symbolValue[String.emptyString] as? String
				}
			}.done { symbol in
				assetInfo.updateValue(symbol, forKey: ABIMethodCall.symbol)
				seal.fulfill(assetInfo)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}
    
    public func calculateEthGasFee() -> Promise<GasInfo> {
        gasInfoManager.calculateEthGasFee()
	}

    public func calculateSendERCGasFee(
		address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
        gasInfoManager.calculateSendERCGasFee(recipient: address, amount: amount, tokenContractAddress: tokenContractAddress)
	}
        
	public func sendEtherTo(address: String, amount: BigUInt) -> Promise<String> {
        transferManager.sendEtherTo(recipient: address, amount: amount)
	}

	public func sendERC20TokenTo(
        recipient: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<String> {
        transferManager.sendERC20TokenTo(recipientAddress: recipient, amount: amount, tokenContractAddress: tokenContractAddress)
	}

	// MARK: - Private Methods


	private func getInfo(address: String, info: ABIMethodCall) throws -> Promise<[String: Any]> {
		let contractAddress = try EthereumAddress(hex: address, eip55: true)
		let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
		let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
		return contract[info.rawValue]!(contractAddress).call()
	}
    
    private func callABIMethod<T, ABIParams: ABIEncodable>(method: ABIMethodCall, contractAddress: EthereumAddress, params:ABIParams...) throws -> Promise<T> {
        let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
        // You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
        let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
        // Get balance of some address
            
        return Promise<T>() { seal in
            firstly {
                contract[method.rawValue]!(params).call()
            }.map { response in
                response[.emptyString] as! T
            }.done({ allowance in
                seal.fulfill(allowance)
            }).catch(policy: .allErrors) { error in
                print(error)
                seal.reject(error)
            }
        }
    }

    public static func getContractOfToken(address tokenContractAddress: String, web3: Web3) throws -> DynamicContract {
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
	
    public enum Constants {
        static let ethGasLimit = "21000"
        static let eoaCode = "0x"
        static let permitAddress = "0x000000000022D473030F116dDEE9F6B43aC78BA3"
        static let pinoProxyAddress = "0x118E662de0C4cdc2f8AD0fb1c6Ef4a85222baCF0"
    }

}
