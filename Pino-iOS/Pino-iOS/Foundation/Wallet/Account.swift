//
//  Account.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3

public class Account {
	// MARK: - Public Property

	public var address: EthereumAddress
	public var derivationPath: String? /// For Accounts derived from HDWallet
	public var publicKey: EthereumPublicKey
	public var accountSource: Wallet.WalletType
	public var privateKey: Data

	public var eip55Address: String {
		address.hex(eip55: true)
	}

	// MARK: - Initializers

	convenience init(privateKeyData: Data, accountSource: Wallet.WalletType = .hdWallet) throws {
		guard WalletValidator.isPrivateKeyValid(key: privateKeyData)
		else { throw WalletOperationError.validator(.privateKeyIsInvalid) }
		let privateKey = try EthereumPrivateKey(privateKeyData)
		let publicKey = privateKey.publicKey
		try self.init(publicKey: publicKey, accountSource: accountSource, privateKey: privateKeyData)
	}

	init(publicKey: EthereumPublicKey, accountSource: Wallet.WalletType = .hdWallet, privateKey: Data) throws {
		self.derivationPath = nil
		self.publicKey = publicKey
		self.address = publicKey.address
		self.accountSource = accountSource
		self.privateKey = privateKey
	}
}

extension Account: Equatable {
	public static func == (lhs: Account, rhs: Account) -> Bool {
		lhs.address == rhs.address
	}
}
