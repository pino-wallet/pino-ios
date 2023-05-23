//
//  PinoNonHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

protocol PinoNonHDWalletType: PinoWallet {
	mutating func importAccount(privateKey: String) -> Result<Account, WalletOperationError>
}

public struct PinoNonHDWallet: PinoNonHDWalletType {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()

	// MARK: - Public Properties

	public var accounts: [Account] {
		getAllAccounts()
	}

	// MARK: - Public Methods

	public mutating func importAccount(privateKey: String) -> Result<Account, WalletOperationError> {
		do {
			guard WalletValidator.isPrivateKeyValid(key: privateKey)
			else { return .failure(.validator(.privateKeyIsInvalid)) }
			guard let keyData = Data(hexString: privateKey) else { return .failure(.validator(.privateKeyIsInvalid)) }
			let account = try Account(privateKeyData: keyData)
			guard !accountExist(account: account) else { return .failure(.wallet(.accountAlreadyExists)) }
			account.isActiveAccount = true
			let key = KeychainManager.privateKey.getKey(account.eip55Address)
			let keyCipherData = secureEnclave.encrypt(
				plainData: keyData,
				withPublicKeyLabel: key
			)
			if !KeychainManager.privateKey.setValue(
				value: keyCipherData,
				key: key
			) {
				return .failure(.wallet(.importAccountFailed))
			}
			return .success(account)
		} catch {
			return .failure(.wallet(.importAccountFailed))
		}
	}
}
