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
