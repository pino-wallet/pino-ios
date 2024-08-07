//
//  WalletDataSource.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

import CoreData
import Foundation

struct AccountDataSource: DataSourceProtocol {
	// MARK: - Private Properties

	private var accounts = [WalletAccount]()

	// MARK: - Initializers

	init() {
		fetchEntities()
	}

	// MARK: - Internal Methods

	internal mutating func fetchEntities() {
		let accountFetch: NSFetchRequest<WalletAccount> = WalletAccount.fetchRequest()
		accountFetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(WalletAccount.name), ascending: true)]
		do {
			let results = try managedContext.fetch(accountFetch)
			accounts = results
		} catch let error as NSError {
			fatalError("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: - Public Methods

	public mutating func getAll() -> [WalletAccount] {
		fetchEntities()
		return accounts
	}

	public func getBy(id: String) -> WalletAccount? {
		accounts.first(where: { $0.publicKey.lowercased() == id.lowercased() })
	}

	public func get(byWalletType type: Wallet.WalletType) -> [WalletAccount] {
		accounts.filter { $0.wallet.walletType == type }
	}

	public mutating func save(_ account: WalletAccount) {
		if let index = accounts.firstIndex(where: { $0.publicKey.lowercased() == account.publicKey.lowercased() }) {
			accounts[index] = account
		} else {
			accounts.append(account)
		}
		coreDataStack.saveContext()
	}

	public mutating func delete(_ account: WalletAccount) {
		let isAccountSelected = account.isSelected
		accounts.removeAll(where: { $0.publicKey.lowercased() == account.publicKey.lowercased() })
		managedContext.delete(account)
		coreDataStack.saveContext()
		if isAccountSelected {
			updateSelected(accounts.first!)
		}
	}

	public mutating func deleteAllAccounts() {
		accounts.forEach { act in
			managedContext.delete(act)
		}
		accounts.removeAll()
		coreDataStack.saveContext()
	}

	public func filter(_ predicate: (WalletAccount) -> Bool) -> [WalletAccount] {
		accounts.filter(predicate)
	}

	public func sort(by sorter: (WalletAccount, WalletAccount) -> Bool) -> [WalletAccount] {
		accounts.sorted(by: sorter)
	}

	public func updateSelected(_ selectedWallet: WalletAccount) {
		for account in accounts {
			if account == selectedWallet {
				account.isSelected = true
			} else {
				account.isSelected = false
			}
		}
		coreDataStack.saveContext()
	}
}
