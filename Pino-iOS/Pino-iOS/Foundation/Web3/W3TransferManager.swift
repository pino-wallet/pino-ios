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
			let reqNonce = BigUInt(456_789)
			let deadline = EthereumQuantity(quantity: BigUInt(Date().timeIntervalSince1970) + 1_800_000)

			let permitModel = Permit2Model(
				permitted: .init(token: tokenAdd.eip55Address!, amount: amount.etherumQuantity),
				nonce: try! EthereumQuantity(reqNonce),
				deadline: deadline
			)

			let permitTransModel = PermitTransferModel(_permit: permitModel, _signature: signiture)

			let solInvocation = contract[ABIMethodWrite.permitTransferFrom.rawValue]?(
                permitModel,
                abiEncodeString(signiture)
			)
            
            let trx = try trxManager.createTransactionFor(
                contract: solInvocation!,
                nonce: reqNonce.etherumQuantity,
                gasPrice: 200000.bigNumber.bigUInt.etherumQuantity,
                gasLimit: 200000.bigNumber.bigUInt.etherumQuantity
            )
            
            let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
            seal.fulfill(signedTx.data.hex())
                        
//			gasInfoManager.calculateGasOf(
//				method: .permitTransferFrom,
//				solInvoc: solInvocation!,
//				contractAddress: contract.address!
//			)
//			.then { [self] gasInfo in
//				web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
//					.map { ($0, gasInfo) }
//			}
//			.done { [self] nonce, gasInfo in
//
//				let trx = try trxManager.createTransactionFor(
//					contract: solInvocation!,
//					nonce: nonce,
//					gasPrice: gasInfo.gasPrice.etherumQuantity,
//					gasLimit: gasInfo.gasLimit.etherumQuantity
//				)
//
//				let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
//				seal.fulfill(signedTx.data.hex())
//			}.catch { error in
//				seal.reject(error)
//			}
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

func abiEncodeString(_ string: String) -> [UInt8] {
    // Convert the string to a UTF-8 byte array
    let strData = Array(string.utf8)
    let strLength = strData.count
    
    // Encoding the offset (position of the dynamic data). It's 32 bytes in this case because we're assuming only the string needs to be encoded.
    // If there are more parameters, you'll need to adjust the offset accordingly.
    let offset = Array(repeating: UInt8(0), count: 31) + [UInt8(32)]
    
    // Encoding the length of the string
    var lengthBytes = Array(repeating: UInt8(0), count: 32)
    let lengthData = withUnsafeBytes(of: UInt32(strLength).bigEndian) { Array($0) }
    lengthBytes.replaceSubrange(28..<32, with: lengthData)
    
    // Encoding the string data itself, padded to 32 bytes
    var paddedStrData = strData
    while paddedStrData.count % 32 != 0 {
        paddedStrData.append(UInt8(0))
    }
    
    // Concatenating all the byte arrays to form the final ABI encoded parameter
    return offset + lengthBytes + paddedStrData
}
