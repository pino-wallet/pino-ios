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

public struct W3TransferManager: Web3HelperProtocol {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Typealias

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Public Methods

	public func getPermitTransferFromCallData(
		contract: DynamicContract,
		amount: BigUInt,
		tokenAdd: String,
		signiture: String,
		nonce: BigUInt,
		deadline: BigUInt
	) -> Promise<String> {
		Promise<String>() { [self] seal in

			let permitModel = Permit2Model(
				permitted: .init(token: tokenAdd.eip55Address!, amount: amount.etherumQuantity),
				nonce: nonce,
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

	public func getTrxOfSendERC20TokenTo(
		recipientAddress address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> TrxWithGasInfo {
		TrxWithGasInfo { [self] seal in

			let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, abi: .erc, web3: readWeb3)
			let to = try EthereumAddress(hex: address, eip55: true)
			let solInvocation = contract[ABIMethodWrite.transfer.rawValue]?(to, amount)

			gasInfoManager.calculateGasOf(
				method: .transfer,
				solInvoc: solInvocation!
			)
			.then { [self] gasInfo in
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.done { [self] nonce, gasInfo in
				let trx = try trxManager.createTransactionFor(
					contract: solInvocation!,
					nonce: nonce,
					gasInfo: gasInfo
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				seal.fulfill((signedTx, gasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getTrxOfsendEtherTo(recipient address: String, amount: BigUInt) -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				gasInfoManager.calculateEthGasFee(enteredAmount: amount.etherumQuantity, to: address.eip55Address!)
			}.then { [self] gasInfo in
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}.done { [self] nonce, gasInfo in
				let tx = trxManager.createEthSendTrx(
					gasInfo: gasInfo,
					nonce: nonce,
					enteredAmount: amount.etherumQuantity,
					recepient: address.eip55Address!
				)

				let signedTx = try tx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				seal.fulfill((signedTx, gasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
