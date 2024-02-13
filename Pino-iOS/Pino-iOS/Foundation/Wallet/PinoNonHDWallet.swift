//
//  PinoNonHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore

protocol PinoNonHDWalletType: PinoWallet {
	mutating func importAccount(wallet: HDWallet, privateKey: String) -> Result<Account, WalletOperationError>
}

public struct PinoNonHDWallet: PinoNonHDWalletType {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()

	// MARK: - Public Methods

	public mutating func importAccount(wallet: HDWallet, privateKey: String) -> Result<Account, WalletOperationError> {
		do {
			guard WalletValidator.isPrivateKeyValid(key: privateKey)
			else { return .failure(.validator(.privateKeyIsInvalid)) }
			guard let privateKeyData = Data(hexString: privateKey) else { return .failure(.validator(.privateKeyIsInvalid)) }
			let account = try Account(privateKeyData: privateKeyData)
			try saveEncryptedKeys(
				mnemonic: wallet.mnemonic,
				privateKey: privateKeyData,
				accountAddress: account.eip55Address
			)
			return .success(account)
		} catch {
			return .failure(.wallet(.importAccountFailed))
		}
	}

	public func saveEncryptedKeys(mnemonic: String, privateKey: Data, accountAddress: String) throws {
		// We save mnemonics with the prefix of account address in keychain
		// but since accounts can be deleted so will the keys to mnemonics
		// we need to save mnemonics with each created account address in case
		// of account removal another duplicate of mnemonics would still exist in keychain

		let encryptedMnemonicsData = secureEnclave.encrypt(
			plainData: mnemonic.utf8Data,
			withPublicKeyLabel: KeychainManager.mnemonics.getKey(accountAddress)
		)
		let encryptedPrivateKeyData = encryptPrivateKey(privateKey, forAccount: accountAddress)

		if let error = KeychainManager.mnemonics.setValueWithKey(
			value: encryptedMnemonicsData,
			accountAddress: accountAddress
		) {
			throw error
		}
		if let error = KeychainManager.privateKey.setValueWithKey(
			value: encryptedPrivateKeyData,
			accountAddress: accountAddress
		) {
			throw error
		}
	}
}
