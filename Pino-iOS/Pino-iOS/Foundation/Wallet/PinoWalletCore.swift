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
	
    // MARK: - Private Properties

    fileprivate var secureEnclave: SecureEnclave {
		.init()
	}
    
    fileprivate var coreDataManager: CoreDataManager {
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

    @discardableResult
	internal func encryptPrivateKey(_ key: Data, forAccount account: Account) -> Data {
		secureEnclave.encrypt(plainData: key, withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account))
	}

	internal func decryptPrivateKey(fromEncryptedData encryptedData: Data, forAccount account: Account) -> Data {
		secureEnclave.decrypt(
			cipherData: encryptedData,
			withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account)
		)
	}

	public func getAllAccounts() -> [Account] {
        return coreDataManager.getAllAccounts().map( Account.init )
	}

    public func addNewAccount(_ account: Account) {

        let avatar = Avatar.allCases.randomElement() ?? .green_apple

        coreDataManager.createWallet(
            address: account.eip55Address,
            name: avatar.name,
            avatarIcon: avatar.rawValue,
            avatarColor: avatar.rawValue
        )
    }
    
}
