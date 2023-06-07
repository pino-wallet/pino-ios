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

	// MARK: - Public Methods

	public mutating func importAccount(privateKey: String) -> Result<Account, WalletOperationError> {
		do {
			guard WalletValidator.isPrivateKeyValid(key: privateKey)
			else { return .failure(.validator(.privateKeyIsInvalid)) }
			guard let keyData = Data(hexString: privateKey) else { return .failure(.validator(.privateKeyIsInvalid)) }
			let account = try Account(privateKeyData: keyData)
			let keyCipherData = encryptPrivateKey(keyData, forAccount: account)
			if let error = KeychainManager.privateKey.setValueWithAddress(
				value: keyCipherData,
				add: account.eip55Address
			) {
				return .failure(error)
			}
			return .success(account)
		} catch {
			return .failure(.wallet(.importAccountFailed))
		}
	}
}
