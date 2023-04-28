//
//  PinoHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core


protocol PHDWallet: PinoWallet {
    var seed: Data { get set }
    var mnemonic: String { get set }
    var entropy: Data { get }
    var hdWallet: HDWallet! { get set }
    init(mnemonics: String) throws
    func createAccount() -> Result<Account, WalletOperationError>
    func exportSeedphrase(account: Account) -> Data
}

public class PinoHDWallet: PHDWallet {
   
    var seed: Data
    var mnemonic: String
    var entropy: Data
    var id: String
    var secureEnclave = SecureEnclave()
    var accounts: [Account] = []
    var hdWallet: HDWallet!
    
    required init(mnemonics: String) throws {
        guard WalletValidator.isMnemonicsValid(mnemonic: mnemonics) else {
            throw WalletOperationError.validator(.mnemonicIsInvalid)
        }
        guard let wallet = HDWallet(mnemonic: mnemonics, passphrase: .emptyString) else {
            throw WalletOperationError.wallet(.walletCreationFailed)
        }
        
        self.entropy = wallet.entropy
        self.seed = wallet.seed
        self.mnemonic = mnemonics
        self.id = UUID().uuidString
        
        do {
            let firstAccountPrivateKey = getPrivateKeyOfFirstAccount(wallet: wallet)
            let account = try Account(privateKeyData: firstAccountPrivateKey)
            
            let encryptedSeedData = encryptHdWalletSeed(seed, forAccount: account)
            if !KeychainManager.seed.setValue(value: encryptedSeedData, key: account.eip55Address) {
                throw WalletOperationError.keyManager(.seedStorageFailed)
            }
            
            if accountExist(account: account) {
                throw WalletOperationError.wallet(.accountAlreadyExists)
            } else {
                accounts.append(account)
                self.hdWallet = wallet
            }
        } catch {
            throw error
        }
    }    
    
    func createAccount() -> Result<Account, WalletOperationError> {
        let coinType = CoinType.ethereum
        let derivationPath = "m/44'/60'/0'/0/1"
        let privateKey = hdWallet.getKey(coin: coinType, derivationPath: derivationPath)
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: false)
        let account = try! Account(publicKey: publicKey.data)
        accounts.append(account)
        
        print("Private Key: \(privateKey.data.hexString)")
        print("Public Key: \(publicKey.data.hexString)")
        print("Ethereum Address: \(account)")
        return .success(account)
    }
    
    func getPrivateKeyOfFirstAccount(wallet: HDWallet) -> Data {
        let firstAccountIndex = UInt32(0)
        let changeConstant = UInt32(0)
        let addressIndex = UInt32(0)
        let privateKey = wallet.getDerivedKey(coin: .ethereum, account: firstAccountIndex, change: changeConstant, address: addressIndex)
        return privateKey.data
    }
    
    private func encryptHdWalletSeed(_ seed: Data, forAccount account: Account) -> Data {
        secureEnclave.encrypt(plainData: seed, withPublicKeyLabel: KeychainManager.seed.getKey(account: account))
    }
    
    private func decryptHdWalletSeed(fromEncryptedData encryptedSeed: Data, forAccount account: Account) -> Data {
        secureEnclave.decrypt(cipherData: encryptedSeed, withPublicKeyLabel: KeychainManager.seed.getKey(account: account))
    }

    func exportSeedphrase(account: Account) -> Data {
        let cipherData = KeychainManager.seed.getValueWith(key: account.eip55Address)
        let decryptedSeed = decryptHdWalletSeed(fromEncryptedData: cipherData, forAccount: account)
        return decryptedSeed
    }
    
    
}
