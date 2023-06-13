//
//  Account.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import Web3
import WalletCore

public class Account: Codable {
	// MARK: - Public Property

	public var address: EthereumAddress
	public var derivationPath: String? /// For Accounts derived from HDWallet
	public var publicKey: Data
	public var accountSource: Wallet.WalletType

	public var eip55Address: String {
		address.hex(eip55: true)
	}

	public var privateKey: Data {
		let privateKeyFetchKey = KeychainManager.privateKey.getKey(eip55Address)
		let secureEnclave = SecureEnclave()
		guard let encryptedPrivateKey = KeychainManager.privateKey.getValueWithKey(accountAddress: eip55Address) else {
			fatalError(WalletOperationError.keyManager(.privateKeyRetrievalFailed).localizedDescription)
		}
		let decryptedData = secureEnclave.decrypt(
			cipherData: encryptedPrivateKey,
			withPublicKeyLabel: privateKeyFetchKey
		)
		return decryptedData
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
        let ethPublicKey = try EthereumPublicKey(hexPublicKey: publicKey.hexString)
		self.derivationPath = nil
		self.publicKey = publicKey
        self.address = EthereumAddress(hexString: ethPublicKey.address.hex(eip55: true))!
		self.accountSource = accountSource
	}

	init(account: WalletAccount) {
		self.derivationPath = account.derivationPath
		self.publicKey = account.publicKey
        self.address = EthereumAddress(hexString: account.eip55Address)!
		self.accountSource = account.wallet.walletType
	}
}

extension Account: Equatable {
	public static func == (lhs: Account, rhs: Account) -> Bool {
		lhs.address == rhs.address
	}
}
