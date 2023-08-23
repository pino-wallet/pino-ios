//
//  W3GasInfoManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

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
		contract: SolidityInvocation,
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
					contract: contract,
					nonce: nonce,
					gasPrice: gasPrice,
					gasLimit: nil
				).promise.map { ($0, nonce, gasPrice) }
			}.then { transaction, nonce, gasPrice in

				web3.eth.estimateGas(call: .init(
					from: transaction.from,
					to: contractAddress,
					gas: gasPrice,
					gasPrice: nil,
					value: nil,
					data: transaction.data
				)).map { ($0, nonce, gasPrice) }

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
		Promise<GasInfo>() { seal in
			firstly {
				let to: EthereumAddress = try! EthereumAddress(hex: address, eip55: true)
				let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, web3: web3)
				let solInvocation = contract[ABIMethodWrite.transfer.rawValue]!(to, amount)
				return gasInfoManager.calculateGasOf(method: .transfer, contract: solInvocation, contractAddress: to)
			}.done { trxGasInfo in
				let gasInfo = GasInfo(gasPrice: trxGasInfo.gasPrice, gasLimit: trxGasInfo.gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateApproveFee(
		spender: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let spender: EthereumAddress = try! EthereumAddress(hex: spender, eip55: true)
				let contractAddress: EthereumAddress = try! EthereumAddress(hex: tokenContractAddress, eip55: true)
				let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, web3: web3)
				let solInvocation = contract[ABIMethodWrite.approve.rawValue]!(spender, amount)
				return gasInfoManager.calculateGasOf(
					method: .approve,
					contract: solInvocation,
					contractAddress: contractAddress
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
