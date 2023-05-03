//
//  PinoNonHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

protocol PNonHDWallet: PinoWallet {
	mutating func importAccount(privateKey: Data) -> Result<Account, WalletOperationError>
}

public struct PinoNonHDWallet: PNonHDWallet {
    
    // MARK: - Private Properties

    private var secureEnclave = SecureEnclave()

    // MARK: - Public Properties

	public var accounts: [Account] {
		getAllAccounts()
	}
    
    #warning("this is for testing purposes")
    private var tempAccounts: [Account] = []

    // MARK: - Public Methods

	public mutating func importAccount(privateKey: Data) -> Result<Account, WalletOperationError> {
		do {
			let account = try Account(privateKeyData: privateKey)
			guard accountExist(account: account) else { return .failure(.wallet(.accountAlreadyExists)) }
			addNewAccount(account)
			let keyCipherData = secureEnclave.encrypt(plainData: privateKey, withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account))
			if !KeychainManager.privateKey.setValue(value: keyCipherData, key: KeychainManager.privateKey.getKey(account: account)) {
				return .failure(.wallet(.importAccountFailed))
			}
			return .success(account)
		} catch {
			return .failure(.wallet(.importAccountFailed))
		}
	}

	#warning("read accouns from core data")
	public func getAllAccounts() -> [Account] {
		tempAccounts
	}

	public mutating func addNewAccount(_ account: Account) {
		#warning("write account to core data")
		if !accountExist(account: account) {
            tempAccounts.append(account)
        }
	}
}
