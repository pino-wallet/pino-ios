//
//  ImportAccountsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Foundation

class ImportAccountsViewModel {
	// MARK: Public Properties

	public let pageTitle = "Import account"
	public var pageDescription: String {
		if accounts.count > 1 {
			return "We found \(accounts.count) accounts with activity"
		} else {
			return "We found an account with activity"
		}
	}

	public var footerTitle = "Find more accounts"

	@Published
	public var accounts: [ActiveAccountViewModel]!

	// MARK: - Initializers

	init() {
		getAccounts()
	}

	// MARK: - Private Methods

	private func getAccounts() {
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
			ActiveAccountViewModel(
				id: "1",
				name: "Avocado",
				address: "2365627638742",
				profileImage: "avocado",
				profileColor: "avocado",
				balance: "28",
				isSelected: false
			),
		]
	}

	// MARK: - Public Methods

	public func findMoreAccounts(completion: @escaping () -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
			completion()
			let avatar = Avatar.randAvatar()
			self.accounts.append(ActiveAccountViewModel(
				id: "0",
				name: avatar.name,
				address: "2365627638742",
				profileImage: avatar.rawValue,
				profileColor: avatar.rawValue,
				balance: "100",
				isSelected: false
			))
		}
	}
}
