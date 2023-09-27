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

			let reqNonce = BigUInt(1245)
			//            let deadline = EthereumQuantity(quantity: BigUInt(Date().timeIntervalSince1970) + 1_800_000)
			let deadline = BigUInt("11579208923731619542357098").etherumQuantity

			let permitModel = Permit2Model(
				permitted: .init(token: tokenAdd.eip55Address!, amount: amount.etherumQuantity),
				nonce: reqNonce.etherumQuantity,
				deadline: deadline
			)

			let sigData = Data(hexString: signiture, length: 130)

			let permitTransffrom = PermitTransferFrom(permitted: permitModel, signature: sigData!)

			let solInvocation = contract[ABIMethodWrite.permitTransferFrom.rawValue]?(
				permitTransffrom
			)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			print(trx.data.hex())

			seal.fulfill(trx.data.hex())
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

// 0xcd93f197
// 000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
// 00000000000000000000000000000000000000000000000000000000000f4240
// 00000000000000000000000000000000000000000000000000000000000011d7
// 0000000000000000000000000000000000000000000000000000020566c4238e
// 00000000000000000000000000000000000000000000000000000000000000a0
// 0000000000000000000000000000000000000000000000000000000000000041
// 7c2af693e83b1e601fbe54a3453ee89bf0aa034efac514f216cb960da3414698
// 7e1dc9136eaa8bfe22cdd203d952ada54e5b9b3d51f12dec1cf4ff1114a39507
// 1b00000000000000000000000000000000000000000000000000000000000000

// 0xcd93f197
// 000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
// 00000000000000000000000000000000000000000000000000000000000f4240
// 00000000000000000000000000000000000000000000000000000000000011d7
// 0000000000000000000000000000000000000000000000000000020566c4238e
// 00000000000000000000000000000000000000000000000000000000000000a0
// 0000000000000000000000000000000000000000000000000000000000000041
// 3bdfaecd8b88c658d295395d6343fead8b3030de200b792ebed2f5c066c1760c
// 51c50ecabf63c65496482dc5fa77ac9ec4becbc475f37f0b73cbacf04481bbcd
// 1c00000000000000000000000000000000000000000000000000000000000000

// 0xcd93f197
// 000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
// 00000000000000000000000000000000000000000000000000000000000f4240
// 00000000000000000000000000000000000000000000000000000000000011d7
// 0000000000000000000000000000000000000000000000000000020566c4238e
// 00000000000000000000000000000000000000000000000000000000000000a0
// 0000000000000000000000000000000000000000000000000000000000000041
// 86c0d01578fa26d0b284e1aafffe2e656dcc47bb622559b669c3dac858aac562
// 76797b6deaf1b89bd653e5c4368cc55f38834a4fe8c26da4867cc6ceb6a5106f
// 0100000000000000000000000000000000000000000000000000000000000000
