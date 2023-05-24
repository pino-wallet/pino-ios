//
//  PinoHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

protocol PinoHDWalletType: PinoWallet {
    func createInitialHDWallet(mnemonics: String) -> WalletOperationError?
    func createAccountIn(wallet: HDWallet, lastIndex: Int) throws -> Account
    func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError> 
}

public class PinoHDWallet: PinoHDWalletType {
   
    // MARK: - Private Properties
    
    private var secureEnclave = SecureEnclave()
    
    // MARK: - Public Methods
    
    public func createInitialHDWallet(mnemonics: String) -> WalletOperationError? {
        let hdWalelt = createHDWallet(mnemonics: mnemonics)
        switch hdWalelt {
        case .success(let createdWallet):
            let createdAccount = createInitialAccountIn(wallet: createdWallet)
            switch createdAccount {
            case .success(let account):
                
                let encryptedMnemonicsData = encryptHdWalletMnemonics(createdWallet.mnemonic, forAccount: account)
                let encryptedPrivateKeyData = encryptPrivateKey(account.privateKey, forAccount: account)
                
                if let error = KeychainManager.mnemonics.setValue(value: encryptedMnemonicsData, key: account.eip55Address) {
                    return error
                }
                if let error = KeychainManager.privateKey.setValue(value: encryptedPrivateKeyData, key: account.eip55Address) {
                    return error
                }
                
            case .failure(let failure):
                return failure
            }
        case .failure(let error):
            return error
        }
        return nil
    }
    
    private func createInitialAccountIn(wallet: HDWallet) -> Result<Account, WalletOperationError> {
        
        let firstAccountPrivateKey = getPrivateKeyOfFirstAccount(wallet: wallet)
        do {
            let account = try Account(privateKeyData: firstAccountPrivateKey)
            return .success(account)
        } catch let error where error is WalletOperationError {
            return .failure(error as! WalletOperationError)
        } catch {
            return .failure(.wallet(.unknownError))
        }
        
    }
    
    public func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError> {
        guard WalletValidator.isMnemonicsValid(mnemonic: mnemonics) else {
            return .failure(.validator(.mnemonicIsInvalid))
        }
        guard let wallet = HDWallet(mnemonic: mnemonics, passphrase: .emptyString) else {
            return .failure(.wallet(.walletCreationFailed))
        }
        
        return .success(wallet)
    }
    
    public func createAccountIn(wallet: HDWallet, lastIndex: Int) throws -> Account {
        let coinType = CoinType.ethereum
        let derivationPath = "m/44'/60'/0'/0/\(lastIndex + 1)"
        let privateKey = wallet.getKey(coin: coinType, derivationPath: derivationPath)
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
        let account = try Account(privateKeyData: privateKey.data)
        account.derivationPath = derivationPath
        
        // We save mnemonics with the prefix of account address in keychain
        // but since accounts can be deleted so will the keys to mnemonics
        // we need to save mnemonics with each created account address in case
        // of account removal another duplicate of mnemonics would still exist in keychain
        let encryptedMnemonicsData = encryptHdWalletMnemonics(wallet.mnemonic, forAccount: account)
        let encryptedPrivateKeyData = encryptPrivateKey(privateKey.data, forAccount: account)
        
        if let error = KeychainManager.mnemonics.setValue(value: encryptedMnemonicsData, key: account.eip55Address) {
            throw error
        }
        if let error = KeychainManager.privateKey.setValue(value: encryptedPrivateKeyData, key: account.eip55Address) {
            throw error
        }
        
        print("Private Key: \(privateKey.data.hexString)")
        print("Public Key: \(publicKey.data.hexString)")
        print("Ethereum Address: \(account)")
        return account
    }
    
    // MARK: - Private Methods
    
    private func getPrivateKeyOfFirstAccount(wallet: HDWallet) -> Data {
        let firstAccountIndex = UInt32(0)
        let changeConstant = UInt32(0)
        let addressIndex = UInt32(0)
        let privateKey = wallet.getDerivedKey(
            coin: .ethereum,
            account: firstAccountIndex,
            change: changeConstant,
            address: addressIndex
        )
        return privateKey.data
    }
    
    private func encryptHdWalletMnemonics(_ mnemonics: String, forAccount account: Account) -> Data {
        secureEnclave.encrypt(
            plainData: mnemonics.utf8Data,
            withPublicKeyLabel: KeychainManager.mnemonics.getKey(account.eip55Address)
        )
    }
    
    private func decryptHdWalletMnemonics(
        fromEncryptedData encryptedMnemonics: Data,
        forAccount account: Account
    ) -> Data {
        secureEnclave.decrypt(
            cipherData: encryptedMnemonics,
            withPublicKeyLabel: KeychainManager.mnemonics.getKey(account.eip55Address)
        )
    }
    
}
