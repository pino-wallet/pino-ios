//
//  ImportAccountsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Foundation

struct ImportAccountsViewModel {
	// MARK: Public Properties

	public var accounts: [ActiveAccountViewModel]!

	// MARK: - Initializers

	init() {
		getAccounts()
	}

	// MARK: - Private Methods

	private mutating func getAccounts() {
		accounts = [
			ActiveAccountViewModel(
				id: "0",
				name: "Lemon",
				address: "2365627638742",
				profileImage: "lemon",
				profileColor: "lemon",
				balance: "24",
				isSelected: true
			),
		]
	}
}
