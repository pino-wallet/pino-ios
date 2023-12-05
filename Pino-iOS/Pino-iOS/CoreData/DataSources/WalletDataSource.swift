//
//  WalletDataSource.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/13/23.
//

import CoreData
import Foundation

struct WalletDataSource: DataSourceProtocol {
	// MARK: - Private Properties

	private var wallets = [Wallet]()

	// MARK: - Initializers

	init() {
		fetchEntities()
	}

	// MARK: - Internal Methods

	internal mutating func fetchEntities() {
		let walletFetch: NSFetchRequest<Wallet> = Wallet.fetchRequest()
		do {
			let results = try managedContext.fetch(walletFetch)
			wallets = results
		} catch let error as NSError {
			fatalError("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: - Public Methods

	public func getAll() -> [Wallet] {
		wallets
	}

	public func getBy(id: String) -> Wallet? {
		wallets.first(where: { $0.objectID.description.lowercased() == id.lowercased() })
	}

	public func get(byType type: Wallet.WalletType) -> Wallet? {
		wallets.first(where: { $0.walletType == type && $0.isSelected == true })
	}

	public mutating func save(_ wallet: Wallet) {
		if let index = wallets.firstIndex(where: { $0.objectID == wallet.objectID }) {
			wallets[index] = wallet
		} else {
			wallets.append(wallet)
		}
		coreDataStack.saveContext()
	}

	public mutating func delete(_ wallet: Wallet) {
		wallets.removeAll(where: { $0.objectID == wallet.objectID })
		managedContext.delete(wallet)
		coreDataStack.saveContext()
	}

	public func filter(_ predicate: (Wallet) -> Bool) -> [Wallet] {
		wallets.filter(predicate)
	}

	public func sort(by sorter: (Wallet, Wallet) -> Bool) -> [Wallet] {
		wallets.sorted(by: sorter)
	}
}
