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

public struct ERC20TrxGasInfo {
    let nonce: BigUInt
    let gasPrice: BigUInt
    let estimate: BigUInt
    let gasLimit: BigUInt
    let trxGas: BigUInt
}

class Web3Core {
    
    // MARK: - Private Properties

	private init() {}
	private var web3: Web3 {
		if let testURL = AboutPinoView.web3URL {
			return Web3(rpcURL: testURL)
		} else {
			return Web3(rpcURL: "https://rpc.ankr.com/eth")
		}
	}

	private let walletManager = PinoWalletManager()

    // MARK: - Yypealias

	typealias CustomAssetInfo = [ABIMethodCall: String]
	typealias GasInfo = (fee: BigNumber, feeInDollar: BigNumber, gasPrice: String, gasLimit: String)
    typealias ERC20GasPromise = Promise<(ERC20TrxGasInfo)>

	// MARK: - Public Properties

	public static var shared = Web3Core()
	
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

	public func calculateEthGasFee(ethPrice: BigNumber) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			attempt(maximumRetryCount: 3) { [self] in
				web3.eth.gasPrice()
			}.done { gasPrice in
				let gasLimit = BigNumber(number: Constants.ethGasLimit, decimal: 0)
				let gasPriceBigNum = BigNumber(number: "\(gasPrice.quantity)", decimal: 0)
				let fee = BigNumber(number: gasLimit * gasPriceBigNum, decimal: 18)
				let feeInDollar = fee * ethPrice
				seal
					.fulfill((fee, feeInDollar, gasPrice: gasPrice.quantity.description, gasLimit: Constants.ethGasLimit))
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateERCGasFee(
		address: String,
		amount: BigUInt,
		tokenContractAddress: String,
		ethPrice: BigNumber
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				calculateERC20TokenFee(transaction: transaction)
			}.done { trxGasInfo in

                let fee = BigNumber(unSignedNumber: trxGasInfo.trxGas, decimal: 18)
				let feeInDollar = fee * ethPrice

				seal.fulfill((
					fee,
					feeInDollar,
                    gasPrice: trxGasInfo.gasPrice,
                    gasLimit: trxGasInfo.gasLimit
				))
			}.catch { error in
				seal.reject(error)
			}
		}
	}
    

	public func sendEtherTo(address: String, amount: BigUInt) -> Promise<String> {
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
	) -> Promise<String> {
		Promise<String>() { [self] seal in

			calculateERC20TokenFee(address: address, amount: amount, tokenContractAddress: tokenContractAddress)
				.then { [self] estimate, transactionInfo -> Promise<EthereumData> in

					let myPrivateKey = try EthereumPrivateKey(
						hexPrivateKey: walletManager.currentAccountPrivateKey
							.string
					)
					let contract = try getContractOfToken(address: tokenContractAddress)
					let to = try EthereumAddress(hex: address, eip55: true)

					guard let transaction = contract["transfer"]?(to, amount).createTransaction(
						nonce: transactionInfo[.nonce],
						gasPrice: transactionInfo[.gasPrice],
						maxFeePerGas: nil,
						maxPriorityFeePerGas: nil,
						gasLimit: try .init(transactionInfo[.gasLimit]!.quantity * BigUInt(110) / BigUInt(100)),
						from: myPrivateKey.address,
						value: 0,
						accessList: [:],
						transactionType: .legacy
					) else {
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

//	private func calculateERC20TokenFee(
//		address: String,
//		amount: BigUInt,
//		tokenContractAddress: String
//	) -> ERC20GasPromise {
//        ERC20GasPromise() { [self] seal in
//
//			let to = try EthereumAddress(hex: address, eip55: true)
//			let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
//			var transactionInfo: ERC20TransactionInfoType = [:]
//			// Send some tokens to another address (locally signing the transaction)
//
//			firstly {
//				web3.eth.gasPrice()
//			}.map { gasPrice in
//				transactionInfo.updateValue(gasPrice, forKey: .gasPrice)
//			}.then { [self] in
//				web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest)
//			}.map { nonce in
//				transactionInfo.updateValue(nonce, forKey: .nonce)
//			}.then { [self] () throws -> Promise<EthereumQuantity> in
//				Promise<EthereumQuantity>() { seal in
//					firstly {
//						let contract = try getContractOfToken(address: tokenContractAddress)
//						let transaction = contract["transfer"]?(to, amount).createTransaction(
//							nonce: transactionInfo[.nonce],
//							gasPrice: transactionInfo[.gasPrice],
//							maxFeePerGas: nil,
//							maxPriorityFeePerGas: nil,
//							gasLimit: nil,
//							from: myPrivateKey.address,
//							value: nil,
//							accessList: [:],
//							transactionType: .legacy
//						)
//						return web3.eth.estimateGas(call: .init(
//							from: transaction?.from,
//							to: (transaction?.to)!,
//							gas: transactionInfo[.gasPrice],
//							gasPrice: nil,
//							value: nil,
//							data: transaction!.data
//						))
//					}.done { estimate in
//						seal.fulfill(estimate)
//					}.catch { error in
//						seal.reject(error)
//					}
//				}
//			}.done { gaslimit in
//				transactionInfo.updateValue(gaslimit, forKey: .gasLimit)
//				let estimate = try EthereumQuantity((gaslimit.quantity * BigUInt(110)) / BigUInt(100))
//				let caclulatedFee = estimate.quantity * transactionInfo[.gasPrice]!.quantity
//				seal.fulfill((EthereumQuantity(quantity: caclulatedFee), transactionInfo))
//			}.catch { error in
//				seal.reject(error)
//			}
//		}
//	}
    
    private func calculateERC20TokenFee<ABIParams: ABIEncodable>(contractAddress:String, method: ABIMethodWrite, params: ABIParams...) -> Promise<(ERC20TrxGasInfo)> {
        Promise<(ERC20TrxGasInfo)>() { seal in
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: self.walletManager.currentAccountPrivateKey.string)
            // Send some tokens to another address (locally signing the transaction)
            let trxManager = TransactionManager(contractAddress: contractAddress)

            firstly {
                web3.eth.gasPrice()
            }.then { gasPrice in
                self.web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest).map{ ($0, gasPrice) }
            }.then { nonce, gasPrice in
                trxManager.createTemporaryTransactionFor(method: method, params: params, nonce: nonce, gasPrice: gasPrice).promise.map{ ($0, nonce, gasPrice) }
            }.then { transaction, nonce, gasPrice in
                self.web3.eth.estimateGas(call: .init(to: transaction.to!)).map{ ($0,nonce,gasPrice) }
            }.map { gaslimit, nonce, gasPrice in
                let estimate = try EthereumQuantity((gaslimit.quantity * BigUInt(110)) / BigUInt(100))
                let caclulatedFee = estimate.quantity * gasPrice.quantity
                return (caclulatedFee, gaslimit, nonce, gasPrice, estimate)
            }.done { caclulatedFee, gaslimit, nonce, gasPrice, estimate in
                seal.fulfill(ERC20TrxGasInfo(nonce: nonce.quantity, gasPrice: gasPrice.quantity, estimate: estimate.quantity, gasLimit: gaslimit.quantity, trxGas: caclulatedFee))
            }.catch { error in
                seal.reject(error)
            }
        }
    }

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

	public func getContractOfToken(address tokenContractAddress: String) throws -> DynamicContract {
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

	/// Utitlity function to attemp multiple times for a promise
	func attempt<T>(
		maximumRetryCount: Int = 3,
		delayBeforeRetry: DispatchTimeInterval = .microseconds(500),
		_ body: @escaping () -> Promise<T>
	) -> Promise<T> {
		var attempts = 0
		func attempt() -> Promise<T> {
			attempts += 1
			return body().recover { error -> Promise<T> in
				guard attempts < maximumRetryCount else { throw error }
				return after(delayBeforeRetry).then(attempt)
			}
		}
		return attempt()
	}
}
