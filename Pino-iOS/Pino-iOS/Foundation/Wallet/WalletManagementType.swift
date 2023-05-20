//
//  WalletManagementType.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/20/23.
//

import Foundation

protocol WalletManagement {
    // Attributes
    var accounts: [Account] { get }
    var currentAccount: Account { get }
    var currentHDWallet: HDWallet? { get }

    // Wallet
    func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError>
    func generateMnemonics() -> String
    func exportMnemonics() -> String

    // Account
    func deleteAccount(account: Account) -> Result<Account, WalletOperationError>
    func importAccount(privateKey: String) -> Result<Account, WalletOperationError>
    func exportPrivateKeyFor(account: Account) -> (data: Data, string: String)
}
