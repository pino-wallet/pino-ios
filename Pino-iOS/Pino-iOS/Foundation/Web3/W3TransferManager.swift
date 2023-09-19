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

public struct W3TransferManager {
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

	public func getPermitTransferFromCallData(amount: BigUInt, tokenAdd: String, signiture: String) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .swap,
				web3: web3
			)
            let reqNonce = BigNumber.bigRandomeNumber
			let deadline = EthereumQuantity(quantity: BigUInt(Date().timeIntervalSince1970) + 1_800_000)

			let permitModel = Permit2Model(
				permitted: .init(token: tokenAdd.eip55Address!, amount: amount.etherumQuantity),
                nonce: reqNonce.etherumQuantity,
				deadline: deadline
			)
               
            let signitureData = Data(signiture.hexToBytes())
            let sigData = Data(hexString: signiture, length: 130)

			let solInvocation = contract[ABIMethodWrite.permitTransferFrom.rawValue]?(
                permitModel,
                sigData!
			)
            
            solInvocation!.estimateGas(from: contract.address!, gas: EthereumQuantity(quantity: 1234567), value: nil).done({ estimate in
                print(estimate)
            }).catch({ err in
                print(err)
            })
                        
            let trx = try trxManager.createTransactionFor(
                contract: solInvocation!,
                nonce: EthereumQuantity(reqNonce),
                gasPrice: EthereumQuantity(1231),
                gasLimit: EthereumQuantity(1231)
            )
                        
                        print(trx.data.hex())
            
			gasInfoManager.calculateGasOf(
				method: .permitTransferFrom,
				solInvoc: solInvocation!,
				contractAddress: contract.address!
			)
			.then { [self] gasInfo in
				web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.done { [self] nonce, gasInfo in

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

	public func sendERC20TokenTo(
		recipientAddress address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, abi: .erc, web3: web3)
			let to = try EthereumAddress(hex: address, eip55: true)
			let solInvocation = contract[ABIMethodWrite.transfer.rawValue]?(to, amount)

			gasInfoManager.calculateGasOf(
				method: .transfer,
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

	public func sendEtherTo(recipient address: String, amount: BigUInt) -> Promise<String> {
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
}

func abiEncodeStringToBytes(_ input: String) -> [UInt8] {
    // Convert the string to data
    let inputData = input.data(using: .utf8)!
    
    // Calculate the length prefix as a 32-byte integer
    var lengthData = Data(count: 32)
    var count = inputData.count
    lengthData.replaceSubrange((32 - MemoryLayout.size(ofValue: count))..<32, with: Data(bytes: &count, count: MemoryLayout.size(ofValue: count)))
    
    // Right-pad the string data to a multiple of 32 bytes
    let paddingLength = 32 - (inputData.count % 32)
    let paddedData = inputData + Data(repeating: 0, count: paddingLength)
    
    return Array(lengthData + paddedData)
}

func encodePermitTransferFrom(token: String, amount: UInt64, nonce: UInt64, deadline: UInt64, signature: String) -> String {
    // Function signature
    let functionSignature = "cd93f197"
    
    // Convert parameters to 32-byte hex strings
    let tokenPadded = token.padding(toLength: 64, withPad: "0", startingAt: 0)
    let amountPadded = String(format: "%064x", amount)
    let noncePadded = String(format: "%064x", nonce)
    let deadlinePadded = String(format: "%064x", deadline)
    
    // Signature encoding
    let signatureOffset = "00000000000000000000000000000000000000000000000000000000000000a0"
    let signatureLength = "0000000000000000000000000000000000000000000000000000000000000041"
    
    // Combine all parts
    let callData = functionSignature + tokenPadded + amountPadded + noncePadded + deadlinePadded + signatureOffset + signatureLength + signature
    
    return callData
}
