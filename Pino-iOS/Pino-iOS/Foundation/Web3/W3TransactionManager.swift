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

public struct W3TransactionManager {
	// MARK: - Type Aliases

	typealias Transaction = EthereumTransaction

	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var walletManager = PinoWalletManager()

	// MARK: - Public Methods

	public func createTransactionFor(
		contract: SolidityInvocation,
		nonce: EthereumQuantity? = nil,
		gasPrice: EthereumQuantity? = nil,
		gasLimit: EthereumQuantity? = nil,
		value: EthereumQuantity = 0
	) throws -> EthereumTransaction {
		let accountPrivateKey = try EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey.string
		)

		let transaction = contract.createTransaction(
			nonce: nonce,
			gasPrice: gasPrice,
			maxFeePerGas: nil,
			maxPriorityFeePerGas: nil,
			gasLimit: gasLimit,
			from: accountPrivateKey.address,
			value: value,
			accessList: [:],
            transactionType: .legacy
		)

		return transaction!
	}

	public func createTransactionFor(
		nonce: EthereumQuantity? = nil,
		gasPrice: EthereumQuantity? = nil,
		gasLimit: EthereumQuantity? = nil,
		value: EthereumQuantity = 0,
		data: EthereumData,
		to: EthereumAddress
	) throws -> EthereumTransaction {
		let accountPrivateKey = try EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey.string
		)

		let transaction = EthereumTransaction(
			nonce: nonce,
			gasPrice: gasPrice,
			maxFeePerGas: nil,
			maxPriorityFeePerGas: nil,
			gasLimit: gasLimit,
			from: accountPrivateKey.address,
			to: to,
			value: value,
			data: data,
			accessList: [:],
			transactionType: .legacy
		)

		return transaction
	}
}
