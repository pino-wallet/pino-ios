//
//  W3GasInfoManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3GasInfoManager {
	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var transactionManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var walletManager = PinoWalletManager()

	// MARK: - Public Methods

	public func calculateGasOf(
		method: ABIMethodWrite,
		solInvoc: SolidityInvocation,
		contractAddress: EthereumAddress
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)

			firstly {
				web3.eth.gasPrice()
			}.then { gasPrice in
				web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest).map { ($0, gasPrice) }
			}.then { nonce, gasPrice in
				try transactionManager.createTransactionFor(
					contract: solInvoc,
					nonce: nonce,
					gasPrice: gasPrice,
					gasLimit: nil
				).promise.map { ($0, nonce, gasPrice) }
			}.then { transaction, nonce, gasPrice in
				web3.eth.estimateGas(call: .init(
					from: transaction.from,
					to: transaction.to!,
					gasPrice: gasPrice,
					data: transaction.data
				)).map { ($0, nonce, gasPrice) }

			}.done { gasLimit, nonce, gasPrice in
				let gasInfo =
					GasInfo(
						gasPrice: BigNumber(unSignedNumber: gasPrice.quantity, decimal: 0),
						gasLimit: BigNumber(unSignedNumber: try! BigUInt(gasLimit), decimal: 0)
					)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

//	public func calculateGasOf(
//		data: EthereumData,
//		to: EthereumAddress,
//		value: EthereumQuantity? = nil
//	) -> Promise<GasInfo> {
//		Promise<GasInfo> { seal in
//
//			let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
//            let startTime: Date! = Date()
//
//			firstly {
//
//                let gasPrice = GlobalVariables.shared.ethGasFee
//				return web3.eth
//					.estimateGas(call: .init(
//						from: myPrivateKey.address,
//						to: to,
//                        gasPrice: gasPrice?.gasPrice.etherumQuantity,
//						value: value,
//						data: data
//					))
//			}.done { estimateGas in
//                let endTime = Date()
//                let executionTime = endTime.timeIntervalSince(startTime)
//                print("FETCH ETH GAS Execution Time: \(executionTime) seconds")
//                
//                let gasPrice = GlobalVariables.shared.ethGasFee.gasPrice
//				let gasInfo =
//					GasInfo(
//						gasPrice: gasPrice,
//						gasLimit: BigNumber(unSignedNumber: try! BigUInt(estimateGas), decimal: 0)
//					)
//				seal.fulfill(gasInfo)
//			}.catch { error in
//				seal.reject(error)
//			}
//		}
//	}

    public func calculateGasOf(
        data: EthereumData,
        to: EthereumAddress,
        value: EthereumQuantity? = nil
    ) -> Promise<GasInfo> {
        Promise<GasInfo> { seal in
            
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
            
            firstly {
                web3.eth.gasPrice()
            }.then { gasPrice in
                web3.eth
                    .estimateGas(call: .init(
                        from: myPrivateKey.address,
                        to: to,
                        gasPrice: (try! BigUInt(gasPrice) * BigUInt(120) / BigUInt(100)).etherumQuantity,
                        value: value,
                        data: data
                    )).map { ($0, gasPrice) }
            }.done { estimateGas, gasPrice in
                let gasInfo =
                GasInfo(
                    gasPrice: BigNumber(unSignedNumber: gasPrice.quantity, decimal: 0),
                    gasLimit: BigNumber(unSignedNumber: try! BigUInt(estimateGas), decimal: 0)
                )
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
				let gasLimit = BigNumber(number: Web3Core.Constants.ethGasLimit, decimal: 0)
				let gasPriceBigNum = BigNumber(unSignedNumber: gasPrice.quantity, decimal: 0)
				let gasInfo = GasInfo(gasPrice: gasPriceBigNum, gasLimit: gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateSendERCGasFee(
		recipient: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, abi: .erc, web3: web3)
				let solInvocation = contract[ABIMethodWrite.transfer.rawValue]!(recipient.eip55Address!, amount)
				return gasInfoManager.calculateGasOf(
					method: .transfer,
					solInvoc: solInvocation,
					contractAddress: contract.address!
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
