//
//  PinoWalletManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/26/23.
//

import Foundation
import PromiseKit

class PinoWalletManager: WalletManagement {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()
	private var pinoHDWallet = PinoHDWallet()
	private var nonHDWallet = PinoNonHDWallet()

	// MARK: - Public Properties

	public var accounts: [WalletAccount] {
		let coreDataManager = CoreDataManager()
		return coreDataManager.getAllWalletAccounts()
	}

	public var currentAccount: WalletAccount {
		guard let foundAccount = accounts.first(where: { $0.isSelected }) else {
			return accounts.last!
		}
		return foundAccount
	}

	public var currentAccountPrivateKey: (data: Data, string: String) {
		try! exportPrivateKeyFor(account: currentAccount)
	}

	// MARK: - Public Methods

	public func generateMnemonics() -> String {
		HDWallet.generateMnemonic(seedPhraseCount: .word12)
	}

	public func createHDWallet(mnemonics: String) -> Promise<Account> {
		pinoHDWallet.createInitialHDWallet(mnemonics: mnemonics)
	}

	public func createHDWalletWith(mnemonics: String, for accounts: [ActiveAccountViewModel]) -> Promise<Void> {
		pinoHDWallet.createHDWallet(with: mnemonics, for: accounts.map { $0.account })
	}

	public func exportMnemonics() -> (string: String, array: [String]) {
		let currentWallet = getCurrentHDWallet()
		return (currentWallet.mnemonic, currentWallet.mnemonic.split(separator: " ").map { String($0) })
	}

	public func createAccount(lastAccountIndex: Int) throws -> Account {
		let account = try pinoHDWallet.createAccountIn(wallet: getCurrentHDWallet(), lastIndex: lastAccountIndex)
		return account
	}

	public func deleteAccount(account: WalletAccount) -> Promise<WalletAccount> {
		Promise<WalletAccount> { seal in
			guard let deletingAccount = accounts.first(where: { $0 == account }) else {
				seal.reject(WalletOperationError.wallet(.accountNotFound))
				return
			}
			if KeychainManager.privateKey.deleteValueWith(key: deletingAccount.eip55Address) {
				seal.fulfill(deletingAccount)
			} else {
				seal.reject(WalletOperationError.wallet(.accountDeletionFailed))
			}
		}
	}

	public func importAccount(privateKey: String) -> Promise<Account> {
		nonHDWallet.importAccount(wallet: getCurrentHDWallet(), privateKey: privateKey)
	}

	public func accountExist(account: WalletAccount) -> Bool {
		accounts.contains(where: { $0 == account })
	}

	public func exportPrivateKeyFor(account: WalletAccount) throws -> (data: Data, string: String) {
		let accountAdd = account.eip55Address
		let privateKeyFetchKey = KeychainManager.privateKey.getKey(accountAdd)
		let secureEnclave = SecureEnclave()
		guard let encryptedPrivateKey = KeychainManager.privateKey.getValueWithKey(accountAddress: accountAdd) else {
			fatalError(WalletOperationError.keyManager(.privateKeyRetrievalFailed).localizedDescription)
		}
		let decryptedData = secureEnclave.decrypt(
			cipherData: encryptedPrivateKey,
			withPublicKeyLabel: privateKeyFetchKey
		)
		return (decryptedData, decryptedData.hexString)
	}

	public func isMnemonicsValid(_ mnemonics: String) -> Bool {
		WalletValidator.isMnemonicsValid(mnemonic: mnemonics)
	}

	public func isPrivatekeyValid(_ key: String) -> Bool {
		WalletValidator.isPrivateKeyValid(key: key)
	}

	// MARK: - Private Methods

	private func getCurrentHDWallet() -> HDWallet {
		let coreDataManager = CoreDataManager()
		let firstAccount: WalletAccount
		if let hdwalletAccount = coreDataManager.getWalletAccountsOfType(walletType: .hdWallet).first {
			firstAccount = hdwalletAccount
		} else {
			firstAccount = coreDataManager.getWalletAccountsOfType(walletType: .nonHDWallet).first!
		}
		let decryptedMnemonicsData = exportMnemonics(key: firstAccount.eip55Address)
		let decryptedMnemonics = String(data: decryptedMnemonicsData, encoding: .utf8)
		guard let decryptedMnemonics else {
			fatalError("Failed to decrypt")
		}
		return pinoHDWallet.createHDWallet(mnemonics: decryptedMnemonics).value!
	}

	private func exportMnemonics(key: String) -> Data {
		guard let encryptedMnemonicsData = KeychainManager.mnemonics.getValueWithKey(accountAddress: key) else {
			fatalError(WalletOperationError.keyManager(.mnemonicsRetrievalFailed).localizedDescription)
		}
		let decryptedMnemonics = secureEnclave.decrypt(
			cipherData: encryptedMnemonicsData,
			withPublicKeyLabel: mnemonicsKeyFetchKey(key: key)
		)
		return decryptedMnemonics
	}

	private func mnemonicsKeyFetchKey(key: String) -> String {
		KeychainManager.mnemonics.getKey(key)
	}
}
