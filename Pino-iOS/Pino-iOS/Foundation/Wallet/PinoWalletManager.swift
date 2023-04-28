//
//  PinoWalletManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/26/23.
//

import Foundation

protocol WalletManagement {
    // Attributes
    var accounts: [Account] { get set }
    var currentAccount: Account! { get set }
    var walletManagementDelegate: PinoWalletDelegate? { get }
    var currentWallet: PinoWallet! { get set }

    // Wallet
    mutating func createHDWallet(mnemonics: String) throws
    func generateMnemonics() -> String
    func exportMnemonics(walletSeed: Data) -> String
    func importWallet(mnemonics: String)
    
    // Account
    func deleteAccount()
    func getAllAccounts() -> [Account]
    func importAccount(privateKey: String)
    func exportPrivateKey() -> Data
    func getPrivateKey(account: Account)
        
}

class PinoWalletManager: WalletManagement {
   
    var accounts: [Account]
    var currentAccount: Account!
    var currentWallet: PinoWallet!
    var secureEnclave = SecureEnclave()
    var walletManagementDelegate: PinoWalletDelegate?

    func generateMnemonics() -> String {
        HDWallet.generateMnemonic(seedPhraseCount: .word12)
    }
    
    func createHDWallet(mnemonics: String) throws {
        let hdWallet = try PinoHDWallet(mnemonics: mnemonics)
        self.currentWallet = hdWallet
        walletManagementDelegate?.walletCreated(wallet: hdWallet)
    }
    
    func exportMnemonics(walletSeed: Data) -> String {
        if let hdWallet = currentWallet as? PinoHDWallet {
            return hdWallet.mnemonic
        } else {
            return ""
        }
    }
    
    func importWallet(mnemonics: String) {
        
    }
    
    func createAccount() {
        let account = (currentWallet as! PinoHDWallet).createAccount()
        switch account {
        case .success(let account):
            print(account)
        case .failure(let error):
            print(error)
        }
    }
    
    func deleteAccount() {
        
    }
    
    func getAllAccounts() -> [Account] {
        return []
    }
    
    func importAccount(privateKey: String) {
        
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
    
    init() {
        accounts = []
    }
    
    
}
