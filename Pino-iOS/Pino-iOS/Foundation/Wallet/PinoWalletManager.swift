//
//  PinoWalletManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/26/23.
//

import Foundation

protocol WalletManagement {
	// Attributes
	var accounts: [Account] { get }
	var currentAccount: Account { get }
	var currentWallet: HDWallet? { get }

	// Wallet
	func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError>
	func generateMnemonics() -> String
	func exportMnemonics() -> String

	// Account
	func deleteAccount(account: Account) -> Result<Account, WalletOperationError>
	func importAccount(privateKey: String) -> Result<Account, WalletOperationError>
	func exportPrivateKeyFor(account: Account) -> Data
}

class PinoWalletManager: WalletManagement {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()
	private var pinoHDWallet = PinoHDWallet()
	private var nonHDWallet = PinoNonHDWallet()

	private var privateKeyFetchKey: String {
		KeychainManager.privateKey.getKey(account: currentAccount)
	}

	private var mnemonicsKeyFetchKey: String {
		KeychainManager.mnemonics.getKey(account: currentAccount)
	}

	// MARK: - Public Properties

	public var accounts: [Account] {
		pinoHDWallet.getAllAccounts() + nonHDWallet.getAllAccounts()
	}

	public var currentWallet: HDWallet? {
		let decryptedMnemonicsData = exportMnemonics(account: currentAccount)
		let decryptedMnemonics = String(data: decryptedMnemonicsData, encoding: .utf8)
		guard let decryptedMnemonics else {
			return nil
		}
		switch pinoHDWallet.createHDWallet(mnemonics: decryptedMnemonics) {
		case let .success(wallet):
			return wallet
		case .failure:
			return nil
		}
	}

	public var currentAccount: Account {
		guard let foundAccount = accounts.last(where: { $0.isActiveAccount }) else {
			return accounts.last!
		}
		return foundAccount
	}

	// MARK: - Public Methods

	public func generateMnemonics() -> String {
		HDWallet.generateMnemonic(seedPhraseCount: .word12)
	}

	public func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError> {
		let hdWallet = pinoHDWallet.createHDWallet(mnemonics: mnemonics)
		return hdWallet
	}

	public func exportMnemonics() -> String {
		#warning("be careful of force unwrap")
		return currentWallet!.mnemonic
	}

	public func createAccount() {
		#warning("be careful of force unwrap")
		let account = try! pinoHDWallet.createAccountIn(wallet: currentWallet!)
		switch account {
		case let .success(account):
			print(account)
		case let .failure(error):
			print(error)
		}
	}

	public func deleteAccount(account: Account) -> Result<Account, WalletOperationError> {
		pinoHDWallet.deleteAccount(account: account)
	}

	public func importAccount(privateKey: String) -> Result<Account, WalletOperationError> {
		nonHDWallet.importAccount(privateKey: privateKey)
	}

	public func exportPrivateKeyFor(account: Account) -> Data {
		guard let encryptedPrivateKey = KeychainManager.privateKey.getValueWith(key: account.eip55Address) else {
			fatalError(WalletOperationError.keyManager(.privateKeyRetrievalFailed).localizedDescription)
		}
		return secureEnclave.decrypt(cipherData: encryptedPrivateKey, withPublicKeyLabel: privateKeyFetchKey)
	}

	public func isMnemonicsValid(_ mnemonics: String) -> Bool {
		WalletValidator.isMnemonicsValid(mnemonic: mnemonics)
	}

	public func isPrivatekeyValid(_ key: String) -> Bool {
		WalletValidator.isPrivateKeyValid(key: key)
	}

	// MARK: - Private Methods

	private func exportMnemonics(account: Account) -> Data {
		guard let encryptedMnemonicsData = KeychainManager.mnemonics.getValueWith(key: account.eip55Address) else {
			fatalError(WalletOperationError.keyManager(.mnemonicsRetrievalFailed).localizedDescription)
		}
		let decryptedMnemonics = secureEnclave.decrypt(
			cipherData: encryptedMnemonicsData,
			withPublicKeyLabel: mnemonicsKeyFetchKey
		)
		return decryptedMnemonics
	}
}
