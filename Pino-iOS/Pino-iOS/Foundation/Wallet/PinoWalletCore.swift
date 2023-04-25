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
    var id: String { get }
    var accounts: [Account] { get set }
    var error: WalletError { get set }
    var secureEnclave: SecureEnclave { get }
    var walletManagementDelegate: PinoWalletDelegate { get set }
    func accountExist(account: Account) -> Bool
    func deleteAccount(account: Account) -> Result<Account, WalletOperationError>
}

extension PinoWallet {
   
    func accountExist(account: Account) -> Bool {
        accounts.contains(where: { $0 == account })
    }
    
    func deleteAccount(account: Account) -> Result<Account, WalletOperationError> {
        guard let deletingAccount = accounts.first(where: { $0 == account }) else {
            return .failure(.wallet(.accountNotFound))
        }
        if KeychainManager.privateKey.deleteValueWith(key: deletingAccount.eip55Address) {
            return .success(deletingAccount)
        } else {
            return .failure(.wallet(.accountDeletionFailed))
        }
    }
    
    private func encryptPrivateKey(_ key: Data, forAccount account: Account) -> Data {
        secureEnclave.encrypt(plainData: key, withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account))

    }
    
    private func decryptPrivateKey(fromEncryptedData encryptedData: Data, forAccount account: Account) -> Data {
        secureEnclave.decrypt(cipherData: encryptedData, withPublicKeyLabel: KeychainManager.privateKey.getKey(account: account))
    }
    
}


protocol PinoWalletDelegate {
    func walletCreated(wallet: PinoWallet)
    func accountCreated(account: Account)
    func accountDeleted(account: Account)
}


