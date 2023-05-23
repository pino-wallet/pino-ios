//
//  PinoWalletManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/26/23.
//

import Foundation

class PinoWalletManager: WalletManagement {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()
	private var pinoHDWallet = PinoHDWallet()
	private var nonHDWallet = PinoNonHDWallet()

	// MARK: - Public Properties

	public var accounts: [Account] {
		let coreDataManager = CoreDataManager()
		return coreDataManager.getAllWalletAccounts().map(Account.init)
	}

	public var currentAccount: Account {
		guard let foundAccount = accounts.first(where: { $0.isActiveAccount }) else {
			return accounts.last!
		}
		return foundAccount
	}

	public var currentHDWallet: HDWallet? {
		let coreDataManager = CoreDataManager()
		let hdwalletAccount = coreDataManager.getWalletAccountsOfType(walletType: .hdWallet).first!
		let decryptedMnemonicsData = exportMnemonics(key: hdwalletAccount.eip55Address)
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

	// MARK: - Public Methods

	public func generateMnemonics() -> String {
		HDWallet.generateMnemonic(seedPhraseCount: .word12)
	}

	public func createHDWallet(mnemonics: String) -> WalletOperationError? {
        pinoHDWallet.createInitialHDWallet(mnemonics: mnemonics)
	}

	public func exportMnemonics() -> (string: String, array: [String]) {
		#warning("be careful of force unwrap")
		return (currentHDWallet!.mnemonic, currentHDWallet!.mnemonic.split(separator: " ").map { String($0) })
	}

	public func createAccount(lastAccountIndex: Int) throws -> Account {
		let account = try pinoHDWallet.createAccountIn(wallet: currentHDWallet!, lastIndex: lastAccountIndex)
		return account
	}

	public func deleteAccount(account: Account) -> Result<Account, WalletOperationError> {
		pinoHDWallet.deleteAccount(account: account)
	}

	public func importAccount(privateKey: String) -> Result<Account, WalletOperationError> {
		nonHDWallet.importAccount(privateKey: privateKey)
	}

	public func exportPrivateKeyFor(account: Account) -> (data: Data, string: String) {
		(account.privateKey, account.privateKey.hexString)
	}

	public func isMnemonicsValid(_ mnemonics: String) -> Bool {
		WalletValidator.isMnemonicsValid(mnemonic: mnemonics)
	}

	public func isPrivatekeyValid(_ key: String) -> Bool {
		WalletValidator.isPrivateKeyValid(key: key)
	}

	// MARK: - Private Methods

	private func exportMnemonics(key: String) -> Data {
		guard let encryptedMnemonicsData = KeychainManager.mnemonics.getValueWith(key: key) else {
			fatalError(WalletOperationError.keyManager(.mnemonicsRetrievalFailed).localizedDescription)
		}
		let decryptedMnemonics = secureEnclave.decrypt(
			cipherData: encryptedMnemonicsData,
			withPublicKeyLabel: mnemonicsKeyFetchKey(key: key)
		)
		return decryptedMnemonics
	}

	private func privateKeyFetchKey(key: String) -> String {
		KeychainManager.privateKey.getKey(key)
	}

	private func mnemonicsKeyFetchKey(key: String) -> String {
		KeychainManager.mnemonics.getKey(key)
	}
}
