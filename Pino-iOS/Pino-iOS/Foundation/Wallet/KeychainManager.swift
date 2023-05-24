//
//  KeychainManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

enum KeychainManager: String {
	case mnemonics
	case privateKey

	public func getValueWith(key: String) -> Data? {
		let keychainHelper = KeychainSwift()
		return keychainHelper.getData("\(self)\(key)")
	}

	public func setValue(value: Data, key: String) -> WalletOperationError? {
		let keychainHelper = KeychainSwift()
		if getValueWith(key: key) != nil {
			// Value already exists
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

	public func deleteValueWith(key: String) -> Bool {
		let keychainHelper = KeychainSwift()
		return keychainHelper.delete("\(self)\(key)")
	}

	public func getKey(_ key: String) -> String {
		"\(self)\(key)"
	}
}
