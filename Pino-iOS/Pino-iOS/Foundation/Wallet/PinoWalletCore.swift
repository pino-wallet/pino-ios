//
//  WalletCore.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/16/23.
//

import Foundation
import WalletCore

protocol PinoWallet {
	func encryptPrivateKey(_ key: Data, forAccount account: Account) -> Data
	func decryptPrivateKey(fromEncryptedData encryptedData: Data, forAccount account: Account) -> Data
}

extension PinoWallet {
	// MARK: - Private Properties

	fileprivate var secureEnclave: SecureEnclave {
		.init()
	}

	// MARK: - Internal Methods

	@discardableResult
	internal func encryptPrivateKey(_ key: Data, forAccount account: Account) -> Data {
		secureEnclave.encrypt(plainData: key, withPublicKeyLabel: KeychainManager.privateKey.getKey(account.eip55Address))
	}

	internal func decryptPrivateKey(fromEncryptedData encryptedData: Data, forAccount account: Account) -> Data {
		secureEnclave.decrypt(
			cipherData: encryptedData,
			withPublicKeyLabel: KeychainManager.privateKey.getKey(account.eip55Address)
		)
	}
}
