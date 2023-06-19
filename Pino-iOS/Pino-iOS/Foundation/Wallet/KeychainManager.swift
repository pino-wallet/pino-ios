//
//  KeychainManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore

enum KeychainManager: String {
	case mnemonics
	case privateKey

	// MARK: - Public Methods

	public func getValueWithKey(accountAddress: String) -> Data? {
		let key = getKey(accountAddress)
		return getValueWith(key: key)
	}

	public func setValueWithKey(value: Data, accountAddress: String) -> WalletOperationError? {
		let key = getKey(accountAddress)
		return setValue(value: value, key: key)
	}

	public func deleteValueWith(key: String) -> Bool {
		let keychainHelper = KeychainSwift()
		return keychainHelper.delete("\(self)\(key)")
	}

	public func getKey(_ key: String) -> String {
		"\(self)\(key)"
	}

	// MARK: - Private Methods

	private func getValueWith(key: String) -> Data? {
		let keychainHelper = KeychainSwift()
		return keychainHelper.getData(key)
	}

	private func setValue(value: Data, key: String) -> WalletOperationError? {
		let keychainHelper = KeychainSwift()
		if getValueWith(key: key) != nil {
			// Value already exists
			return nil
		} else {
			if keychainHelper.set(value, forKey: key) {
				return nil
			} else {
				switch self {
				case .mnemonics:
					return .keyManager(.mnemonicsStorageFailed)
				case .privateKey:
					return .keyManager(.privateKeyStorageFailed)
				}
			}
		}
	}
}
