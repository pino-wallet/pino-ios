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
    var walletManagementDelegate: PinoWalletDelegate? { get }
    var currentWallet: HDWallet? { get }

    // Wallet
    func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError>
    func generateMnemonics() -> String
    func exportMnemonics() -> String
    
    // Account
    func deleteAccount(account: Account) -> Result<Account, WalletOperationError>
    func importAccount(privateKey: Data) -> Result<Account, WalletOperationError>
    func exportPrivateKey() -> Data
    func getPrivateKey(account: Account)
        
}

class PinoWalletManager: WalletManagement {
    public var walletManagementDelegate: PinoWalletDelegate?
    
    private var secureEnclave = SecureEnclave()
    private var pinoHDWallet = PinoHDWallet()
    private var nonHDWallet = PinoNonHDWallet()
    
    var accounts: [Account] {
        pinoHDWallet.getAllAccounts() + nonHDWallet.getAllAccounts()
    }
    
    var currentWallet: HDWallet? {
        get {
            let decryptedSeed = exportSeedphrase(account: currentAccount)
            switch pinoHDWallet.createHDWallet(seed: decryptedSeed) {
            case .success(let wallet):
                return wallet
            case .failure(_):
                return nil
            }
        }
        set {
            self.currentWallet = newValue
        }
    }
    
    var currentAccount: Account {
        guard let foundAccount = accounts.first(where: { $0.isActiveAccount }) else {
            return accounts.first!
        }
        return foundAccount
    }
    
    var fetchKey: String {
        currentAccount.eip55Address
    }
    
    func generateMnemonics() -> String {
        HDWallet.generateMnemonic(seedPhraseCount: .word12)
    }
    
    func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError> {
        let hdWallet = pinoHDWallet.createHDWallet(mnemonics: mnemonics)
        return hdWallet
    }
    
    func exportMnemonics() -> String {
        #warning("be careful of force unwrap")
        return currentWallet!.mnemonic
    }
    
    func createAccount() {
        #warning("be careful of force unwrap")
        let account = try! pinoHDWallet.createAccountIn(wallet: currentWallet!)
        switch account {
        case .success(let account):
            print(account)
        case .failure(let error):
            print(error)
        }
    }
    
    public func deleteAccount(account: Account) -> Result<Account, WalletOperationError> {
        pinoHDWallet.deleteAccount(account: account)
    }
    
    public func importAccount(privateKey: Data) -> Result<Account, WalletOperationError> {
        nonHDWallet.importAccount(privateKey: privateKey)
    }
    
    func exportPrivateKey() -> Data {
        return Data()
    }
    
    func getPrivateKey(account: Account) {
        
    }
    
    private func exportSeedphrase(account: Account) -> Data {
        let encryptedSeedData = KeychainManager.seed.getValueWith(key: account.eip55Address)
        let decryptedSeed = secureEnclave.decrypt(cipherData: encryptedSeedData, withPublicKeyLabel: account.eip55Address)
        return decryptedSeed
    }
    
 
}
