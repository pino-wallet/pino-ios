//
//  WalletDataSource.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

import CoreData
import Foundation

struct WalletDataSource: DataSourceProtocol {
	// MARK: - Private Properties

	private var wallets = [Wallet]()

	// MARK: - Initializers

	init() {
		fetchWallets()
	}

	// MARK: - Private Methods

	private mutating func fetchWallets() {
		let walletFetch: NSFetchRequest<Wallet> = Wallet.fetchRequest()
		do {
			let results = try managedContext.fetch(walletFetch)
			wallets = results
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: - Public Methods

	public func getAll() -> [Wallet] {
		wallets
	}

	public func get(byId id: String) -> Wallet? {
		wallets.first(where: { $0.id == id })
	}

	public mutating func save(_ wallet: Wallet) {
		if let index = wallets.firstIndex(where: { $0.id == wallet.id }) {
			wallets[index] = wallet
		} else {
			wallets.append(wallet)
		}
		coreDataStack.saveContext()
	}

	public mutating func delete(_ wallet: Wallet) {
		let isWalletSelected = wallet.isSelected
		wallets.removeAll(where: { $0.id == wallet.id })
		managedContext.delete(wallet)
		coreDataStack.saveContext()
		if isWalletSelected {
			updateSelected(wallets.first!)
		}
	}

	public func filter(_ predicate: (Wallet) -> Bool) -> [Wallet] {
		wallets.filter(predicate)
	}

	public func sort(by sorter: (Wallet, Wallet) -> Bool) -> [Wallet] {
		wallets.sorted(by: sorter)
	}

	public func updateSelected(_ selectedWallet: Wallet) {
		for wallet in wallets {
			if wallet == selectedWallet {
				wallet.isSelected = true
			} else {
				wallet.isSelected = false
			}
		}
		coreDataStack.saveContext()
	}
}
