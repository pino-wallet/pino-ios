//
//  WalletCore.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/16/23.
//

import Foundation
import WalletCore
import Web3Core

protocol PinoWallet {
	var accounts: [Account] { get }
	func accountExist(account: Account) -> Bool
	func deleteAccount(account: Account) -> Result<Account, WalletOperationError>
	func encryptPrivateKey(_ key: Data, forAccount account: Account) -> Data
	func decryptPrivateKey(fromEncryptedData encryptedData: Data, forAccount account: Account) -> Data
	func getAllAccounts() -> [Account]
	mutating func addNewAccount(_ account: Account)
}

extension PinoWallet {
	fileprivate var secureEnclave: SecureEnclave {
		.init()
	}

	// MARK: - Public Methods

	public func accountExist(account: Account) -> Bool {
		accounts.contains(where: { $0 == account })
	}

	public func deleteAccount(account: Account) -> Result<Account, WalletOperationError> {
		guard let deletingAccount = accounts.first(where: { $0 == account }) else {
			return .failure(.wallet(.accountNotFound))
		}
		if KeychainManager.privateKey.deleteValueWith(key: deletingAccount.eip55Address) {
			return .success(deletingAccount)
		} else {
			return .failure(.wallet(.accountDeletionFailed))
		}
	}

	// MARK: - Private Methods

	internal func encryptPrivateKey(_ key: Data, forAccount account: Account) -> Data {
		secureEnclave.encrypt(plainData: key, withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account))
	}

	internal func decryptPrivateKey(fromEncryptedData encryptedData: Data, forAccount account: Account) -> Data {
		secureEnclave.decrypt(
			cipherData: encryptedData,
			withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account)
		)
	}

	#warning("should read accounts from core data")
	public func getAllAccounts() -> [Account] {
		let userDefaults = UserDefaults.standard
		// 1
		if let savedData = userDefaults.object(forKey: "accounts") as? Data {
			do {
				// 2
				let savedAccounts = try JSONDecoder().decode([Account].self, from: savedData)
				return savedAccounts
			} catch {
				// Failed to convert Data to Contact
				return []
			}
		} else {
			return []
		}
	}

	#warning("write account to core data")
	public func addNewAccount(_ account: Account) {
		if !accountExist(account: account) {
			do {
				// 0
				var allAccounts = getAllAccounts()
				allAccounts.append(account)

				// 1
				let encodedData = try JSONEncoder().encode(allAccounts)
				let userDefaults = UserDefaults.standard

				// 2
				userDefaults.set(encodedData, forKey: "accounts")

			} catch {
				// Failed to encode Contact to Data
			}
		}
	}
}
