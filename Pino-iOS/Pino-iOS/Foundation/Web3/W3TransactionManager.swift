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

protocol TransactionManagerProtocol {
	/// Associated Type
	associatedtype Transaction: Codable

	/// Properties

	/// Functions
	func createTemporaryTransactionFor<Params: ABIEncodable>(
		method: ABIMethodWrite,
		params: Params...,
		nonce: EthereumQuantity,
		gasPrice: EthereumQuantity
	) throws -> Transaction
}

public struct W3TransactionManager {
	// MARK: - Type Aliases

	typealias Transaction = EthereumTransaction

	// MARK: - Internal Properties

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Initilizer

	private let web3: Web3!

	// MARK: - Private Properties

	private var walletManager = PinoWalletManager()

	internal func createTransactionFor(
		method: ABIMethodWrite,
		contract: SolidityInvocation,
		nonce: EthereumQuantity,
		gasPrice: EthereumQuantity,
		gasLimit: EthereumQuantity?
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
			value: nil,
			accessList: [:],
			transactionType: .legacy
		)

		return transaction!
	}
}
