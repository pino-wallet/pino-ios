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

public struct W3SwapManager {
	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var walletManager = PinoWalletManager()
	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var trxManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var userPrivateKey: EthereumPrivateKey {
		try! EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey
				.string
		)
	}

	// MARK: - Public Methods

	public func getSweepTokenCallData(tokenAdd: String, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			gasInfoManager.calculateTokenSweepFee(tokenAdd: tokenAdd, recipientAdd: recipientAdd)
				.then { [self] gasInfo in
					web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
						.map { ($0, gasInfo) }
				}
				.done { [self] nonce, gasInfo in
					let contract = try Web3Core.getContractOfToken(
						address: Web3Core.Constants.pinoProxyAddress,
						web3: web3
					)
					let solInvocation = contract[ABIMethodWrite.sweepToken.rawValue]?(
						tokenAdd.eip55Address!,
						recipientAdd.eip55Address!
					)
					let trx = try trxManager.createTransactionFor(
						contract: solInvocation!,
						nonce: nonce,
						gasPrice: gasInfo.gasPrice.etherumQuantity,
						gasLimit: gasInfo.gasLimit.etherumQuantity
					)

					let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
					seal.fulfill(signedTx.data.hex())
				}.catch { error in
					seal.reject(error)
				}
		}
	}

	public func getWrapETHCallData(amount: BigUInt, proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in
			gasInfoManager.calculateWrapETHFee(amount: amount, proxyFee: proxyFee)
				.then { [self] gasInfo in
					web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
						.map { ($0, gasInfo) }
				}
				.done { [self] nonce, gasInfo in
					let contract = try Web3Core.getContractOfToken(
						address: Web3Core.Constants.pinoProxyAddress,
						web3: web3
					)
					let solInvocation = contract[ABIMethodWrite.wrapETH.rawValue]?(amount, proxyFee)
					let trx = try trxManager.createTransactionFor(
						contract: solInvocation!,
						nonce: nonce,
						gasPrice: gasInfo.gasPrice.etherumQuantity,
						gasLimit: gasInfo.gasLimit.etherumQuantity
					)

					let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
					seal.fulfill(signedTx.data.hex())
				}.catch { error in
					seal.reject(error)
				}
		}
	}

	public func getUnWrapETHCallData(amount: BigUInt, recipient: String) -> Promise<String> {
		Promise<String>() { [self] seal in
			gasInfoManager.calculateUnWrapETHFee(amount: amount, recipient: recipient)
				.then { [self] gasInfo in
					web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
						.map { ($0, gasInfo) }
				}
				.done { [self] nonce, gasInfo in
					let contract = try Web3Core.getContractOfToken(
						address: Web3Core.Constants.pinoProxyAddress,
						web3: web3
					)
					let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(amount, recipient.eip55Address!)
					let trx = try trxManager.createTransactionFor(
						contract: solInvocation!,
						nonce: nonce,
						gasPrice: gasInfo.gasPrice.etherumQuantity,
						gasLimit: gasInfo.gasLimit.etherumQuantity
					)

					let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
					seal.fulfill(signedTx.data.hex())
				}.catch { error in
					seal.reject(error)
				}
		}
	}

	public func callMultiCall(callData: [String]) -> Promise<String> {
		Promise<String>() { [self] seal in
			gasInfoManager.calculateMultiCallFee(callData: callData)
				.then { [self] gasInfo in
					web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
						.map { ($0, gasInfo) }
				}
				.then { [self] nonce, gasInfo in
					let contract = try Web3Core.getContractOfToken(
						address: Web3Core.Constants.pinoProxyAddress,
						web3: web3
					)
					let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(callData)
					let trx = try trxManager.createTransactionFor(
						contract: solInvocation!,
						nonce: nonce,
						gasPrice: gasInfo.gasPrice.etherumQuantity,
						gasLimit: gasInfo.gasLimit.etherumQuantity
					)

					let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
					return web3.eth.sendRawTransaction(transaction: signedTx)
				}.done { txHash in
					seal.fulfill(txHash.hex())
				}.catch { error in
					seal.reject(error)
				}
		}
	}
}