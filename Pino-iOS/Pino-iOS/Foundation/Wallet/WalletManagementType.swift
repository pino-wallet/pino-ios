//
//  WalletManagementType.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/20/23.
//

import Foundation

protocol WalletManagement {
	// Attributes
	var accounts: [WalletAccount] { get }
	var currentAccount: WalletAccount { get }

	// Wallet
    func createHDWallet(mnemonics: String) -> WalletOperationError?
	func generateMnemonics() -> String
	func exportMnemonics() -> (string: String, array: [String])

	// Account
	func deleteAccount(account: WalletAccount) -> Result<WalletAccount, WalletOperationError>
	func importAccount(privateKey: String) -> Result<Account, WalletOperationError>
	func exportPrivateKeyFor(account: WalletAccount) -> (data: Data, string: String)
    func accountExist(account: WalletAccount) -> Bool
}
