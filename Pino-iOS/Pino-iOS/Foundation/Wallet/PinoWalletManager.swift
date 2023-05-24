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
    

	// MARK: - Public Methods

	public func generateMnemonics() -> String {
		HDWallet.generateMnemonic(seedPhraseCount: .word12)
	}

	public func createHDWallet(mnemonics: String) -> WalletOperationError? {
        pinoHDWallet.createInitialHDWallet(mnemonics: mnemonics)
	}

	public func exportMnemonics() -> (string: String, array: [String]) {
		return (currentHDWallet!.mnemonic, currentHDWallet!.mnemonic.split(separator: " ").map { String($0) })
	}

	public func createAccount(lastAccountIndex: Int) throws -> Account {
		let account = try pinoHDWallet.createAccountIn(wallet: currentHDWallet!, lastIndex: lastAccountIndex)
		return account
	}

    public func deleteAccount(account: WalletAccount) -> Result<WalletAccount, WalletOperationError> {
        guard let deletingAccount = accounts.first(where: { $0 == account }) else {
            return .failure(.wallet(.accountNotFound))
        }
        if KeychainManager.privateKey.deleteValueWith(key: deletingAccount.eip55Address) {
            return .success(deletingAccount)
        } else {
            return .failure(.wallet(.accountDeletionFailed))
        }
    }

	public func importAccount(privateKey: String) -> Result<Account, WalletOperationError> {
		nonHDWallet.importAccount(privateKey: privateKey)
	}

    public func accountExist(account: WalletAccount) -> Bool {
        accounts.contains(where: { $0 == account })
    }
    
	public func exportPrivateKeyFor(account: WalletAccount) -> (data: Data, string: String) {
        let account = Account(account: account)
		return (account.privateKey, account.privateKey.hexString)
	}

	public func isMnemonicsValid(_ mnemonics: String) -> Bool {
		WalletValidator.isMnemonicsValid(mnemonic: mnemonics)
	}

	public func isPrivatekeyValid(_ key: String) -> Bool {
		WalletValidator.isPrivateKeyValid(key: key)
	}

	// MARK: - Private Methods

    private var currentHDWallet: HDWallet? {
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

	private func mnemonicsKeyFetchKey(key: String) -> String {
		KeychainManager.mnemonics.getKey(key)
	}
    

    
}
