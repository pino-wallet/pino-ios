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
		fetchWallets()
	}

	// MARK: - Private Methods

	private mutating func fetchWallets() {
		let accountFetch: NSFetchRequest<WalletAccount> = WalletAccount.fetchRequest()
		do {
			let results = try managedContext.fetch(accountFetch)
			accounts = results
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: - Public Methods

	public func getAll() -> [WalletAccount] {
		accounts
	}

	public func get(byId id: String) -> WalletAccount? {
		accounts.first(where: { $0.objectID.description == id })
	}

	public mutating func save(_ account: WalletAccount) {
		if let index = accounts.firstIndex(where: { $0.objectID == account.objectID }) {
			accounts[index] = account
		} else {
			accounts.append(account)
		}
		coreDataStack.saveContext()
	}

	public mutating func delete(_ account: WalletAccount) {
		let isWalletSelected = account.isSelected
		accounts.removeAll(where: { $0.objectID == account.objectID })
		managedContext.delete(account)
		coreDataStack.saveContext()
		if isWalletSelected {
			updateSelected(accounts.first!)
		}
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
