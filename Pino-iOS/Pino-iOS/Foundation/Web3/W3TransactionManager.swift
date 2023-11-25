//
//  TransactionHandler.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/17/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3TransactionManager: Web3HelperProtocol {
	// MARK: - Type Aliases

	typealias Transaction = EthereumTransaction

	var writeWeb3: Web3
	var readWeb3: Web3

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func createTransactionFor(
		contract: SolidityInvocation,
		nonce: EthereumQuantity? = nil,
		gasInfo: GasInfo = GasInfo(),
		value: EthereumQuantity = 0
	) throws -> EthereumTransaction {
		let accountPrivateKey = try EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey.string
		)

		let transaction = contract.createTransaction(
			nonce: nonce,
			gasPrice: nil,
			maxFeePerGas: gasInfo.maxFeePerGas.etherumQuantity,
			maxPriorityFeePerGas: gasInfo.priorityFeePerGas.etherumQuantity,
			gasLimit: gasInfo.increasedGasLimit?.etherumQuantity,
			from: accountPrivateKey.address,
			value: value,
			accessList: [:],
			transactionType: .eip1559
		)

		return transaction!
	}

	public func createTransactionFor(
		nonce: EthereumQuantity? = nil,
		gasInfo: GasInfo,
		value: EthereumQuantity = 0,
		data: EthereumData,
		to: EthereumAddress
	) throws -> EthereumTransaction {
		let accountPrivateKey = try EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey.string
		)

		let transaction = EthereumTransaction(
			nonce: nonce,
			maxFeePerGas: gasInfo.maxFeePerGas.etherumQuantity,
			maxPriorityFeePerGas: gasInfo.priorityFeePerGas.etherumQuantity,
			gasLimit: gasInfo.increasedGasLimit?.etherumQuantity,
			from: accountPrivateKey.address,
			to: to,
			value: value,
			data: data,
			accessList: [:],
			transactionType: .eip1559
		)

		return transaction
	}
}
