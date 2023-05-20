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
	case mainAddress

    public func getValueWith(key: String) -> Data? {
		let keychainHelper = KeychainSwift()
		return keychainHelper.getData("\(self)\(key)")
	}

    public func setValue(value: Data, key: String) -> Bool {
		let keychainHelper = KeychainSwift()
		if getValueWith(key: key) != nil {
			// Value already exists
			return true
		} else {
			return keychainHelper.set(value, forKey: "\(self)\(key)")
		}
	}

    public func setValue(value: String, key: String) -> Bool {
		let keychainHelper = KeychainSwift()
		return keychainHelper.set(value, forKey: "\(self)\(key)")
	}

    public func deleteValueWith(key: String) -> Bool {
		let keychainHelper = KeychainSwift()
		return keychainHelper.delete("\(self)\(key)")
	}

    public func getKey(_ key: String) -> String {
		"\(self)\(key)"
	}
}
