//
//  Account.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

public class Account: Codable {
	// MARK: - Public Property

	public var address: EthereumAddress
	public var derivationPath: String? /// For Accounts derived from HDWallet
	public var publicKey: Data
	public var accountSource: Wallet.WalletType

	public var eip55Address: String {
		address.address
	}

	public var privateKey: Data {
		let privateKeyFetchKey = KeychainManager.privateKey.getKey(eip55Address)
		let secureEnclave = SecureEnclave()
		guard let encryptedPrivateKey = KeychainManager.privateKey.getValueWith(key: eip55Address) else {
			fatalError(WalletOperationError.keyManager(.privateKeyRetrievalFailed).localizedDescription)
		}
		let decryptedData = secureEnclave.decrypt(
			cipherData: encryptedPrivateKey,
			withPublicKeyLabel: privateKeyFetchKey
		)
		let privateKey = PrivateKey(data: decryptedData)
		return privateKey!.data
	}

	// MARK: - Initializers

	convenience init(privateKeyData: Data, accountSource: Wallet.WalletType = .hdWallet) throws {
		guard WalletValidator.isPrivateKeyValid(key: privateKeyData)
		else { throw WalletOperationError.validator(.privateKeyIsInvalid) }
		let privateKey = PrivateKey(data: privateKeyData)!
		let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
		try self.init(publicKey: publicKey.data, accountSource: accountSource)
	}

	init(publicKey: Data, accountSource: Wallet.WalletType = .hdWallet) throws {
		guard WalletValidator.isPublicKeyValid(key: publicKey) else {
			throw WalletOperationError.validator(.publicKeyIsInvalid)
		}
		guard let address = Utilities.publicToAddress(publicKey) else {
			throw WalletOperationError.validator(.addressIsInvalid)
		}
		self.derivationPath = nil
		self.publicKey = publicKey
		self.address = EthereumAddress(address.address)!
		self.accountSource = accountSource
	}

	init(account: WalletAccount) {
		self.derivationPath = account.derivationPath
		self.publicKey = account.publicKey
		self.address = EthereumAddress(account.eip55Address)!
		self.accountSource = account.wallet.walletType
	}
}

extension Account: Equatable {
	public static func == (lhs: Account, rhs: Account) -> Bool {
		lhs.address == rhs.address
	}
}
