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

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.sweepToken.rawValue]?(
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getWrapETHCallData(proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.wrapETH.rawValue]?(proxyFee)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getUnWrapETHCallData(recipient: String) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(recipient.eip55Address!)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func callMultiCall(callData: [String], value: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)

			print(W3CallDataGenerator().generateMultiCallFrom(calls: callData))

			let solInvocation = contract[ABIMethodWrite.multicall.rawValue]?(["hi"])

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!,
				nonce: BigUInt(123).etherumQuantity,
				gasPrice: BigUInt(123).etherumQuantity,
				gasLimit: BigUInt(123_000).etherumQuantity,
				value: BigUInt(0).etherumQuantity
			)

			let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
			print(signedTx.data.hex())
			print(callData.first!.hexToBytes())
			print(Data(callData.first!.hexToBytes()))

			gasInfoManager.calculateGasOf(
				method: .multicall,
				solInvoc: solInvocation!,
				contractAddress: contract.address!
			)
			.then { [self] gasInfo in
				web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.then { [self] nonce, gasInfo in

				let trx = try trxManager.createTransactionFor(
					contract: solInvocation!,
					nonce: nonce,
					gasPrice: gasInfo.gasPrice.etherumQuantity,
					gasLimit: gasInfo.gasLimit.bigUInt.etherumQuantity,
					value: value.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
				return "hash".promise
//				return web3.eth.sendRawTransaction(transaction: signedTx)
			}.done { txHash in
				seal.fulfill(txHash)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getSwapProviderData(callData: String, method: ABIMethodWrite) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)

			// Remove the "0x" prefix if present
			let cleanedHexString = callData.hasPrefix("0x") ? String(callData.dropFirst(2)) : callData

			// Calculate the length in characters
			let lengthInCharacters = cleanedHexString.count

			// Calculate the length in bytes
			let lengthInBytes = lengthInCharacters / 2

			let callD = Data(hexString: callData, length: UInt(lengthInBytes))
			//            let callD2 = Data(callData.hexToBytes())
			//            let str = String.init(data: callD!, encoding: .utf8)!

			let solInvocation = contract[method.rawValue]?(callD!)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}
}
