//
//  PinoNonHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

protocol PNonHDWallet: PinoWallet {
    mutating func importAccount(privateKey: Data) -> Result<Account, WalletOperationError>
}

public struct PinoNonHDWallet: PNonHDWallet {
    
    var id: String
    var accounts: [Account]
    var error: WalletError
    var secureEnclave: SecureEnclave
    var walletValidator: WalletValidator
    var walletManagementDelegate: PinoWalletDelegate
    
    mutating func importAccount(privateKey: Data) -> Result<Account, WalletOperationError> {
        do {
            let account = try Account(privateKey: privateKey)
            guard accountExist(account: account) else { return .failure(.wallet(.accountAlreadyExists))}
            accounts.append(account)
            let keyCipherData = secureEnclave.encrypt(plainData: privateKey, withPublicKeyLabel: account.eip55Address)
            KeychainManager.privateKey.setValue(value: keyCipherData, key: account.eip55Address)
            return .success(account)
        } catch {
            return .failure(.wallet(.walletCreationFailed))
        }
    }
    
}

extension PinoNonHDWallet: Equatable {
    public static func == (lhs: PinoNonHDWallet, rhs: PinoNonHDWallet) -> Bool {
        lhs.id == rhs.id
    }
}

