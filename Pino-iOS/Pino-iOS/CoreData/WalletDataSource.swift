//
//  WalletDataSource.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

import Foundation

struct WalletDataSource: DataSourceProtocol {
	// MARK: - Private Properties

	private var wallets = [Wallet]()

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
	}

	public mutating func delete(_ wallet: Wallet) {
		wallets.removeAll(where: { $0.id == wallet.id })
	}

	public func filter(_ predicate: (Wallet) -> Bool) -> [Wallet] {
		wallets.filter(predicate)
	}

	public func sort(by sorter: (Wallet, Wallet) -> Bool) -> [Wallet] {
		wallets.sorted(by: sorter)
	}
}
