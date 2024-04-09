//
//  WalletManagementType.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/20/23.
//

import Foundation
import PromiseKit

protocol WalletManagement {
	// Attributes
	var accounts: [WalletAccount] { get }
	var currentAccount: WalletAccount { get }

	// Wallet
	func createHDWallet(mnemonics: String) -> Promise<Account>
	func generateMnemonics() -> String
	func exportMnemonics() -> (string: String, array: [String])

	// Account
	func deleteAccount(account: WalletAccount) -> Promise<WalletAccount>
	func importAccount(privateKey: String) -> Promise<Account>
	func exportPrivateKeyFor(account: WalletAccount) throws -> (data: Data, string: String)
	func accountExist(account: WalletAccount) -> Bool
}
