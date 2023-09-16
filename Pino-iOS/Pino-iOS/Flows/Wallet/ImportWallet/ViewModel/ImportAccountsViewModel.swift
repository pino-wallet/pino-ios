//
//  ImportAccountsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Combine
import Foundation

class ImportAccountsViewModel {
	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let internetConnectivity = InternetConnectivity()

	// MARK: Public Properties

	public let pageTitle = "Import account"
	public var pageDescription: String {
		guard let accounts else { return .emptyString }
		if accounts.count > 1 {
			return "We found \(accounts.count) accounts with activity"
		} else {
			return "We found an account with activity"
		}
	}

	public var footerTitle = "Find more accounts"
	public var walletMnemonics: String

	@Published
	public var accounts: [ActiveAccountViewModel]?

	// MARK: - Initializers

	init(walletMnemonics: String) {
		self.walletMnemonics = walletMnemonics
	}

	// MARK: Private Methods

	private func createWallet(mnemonics: String, walletCreated: @escaping (WalletOperationError?) -> Void) {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.sink { _ in } receiveValue: { [self] isConnected in
			if isConnected {
				let initalAccount = pinoWalletManager.createHDWallet(mnemonics: mnemonics)
				switch initalAccount {
				case let .success(account):
					walletCreated(nil)
				case let .failure(failure):
					walletCreated(failure)
				}
			} else {
				walletCreated(.wallet(.netwrokError))
			}
		}.store(in: &cancellables)
	}

	// MARK: - Public Methods

	public func getAccounts(completion: @escaping () -> Void) {
		accountingAPIClient.activeAddresses(addresses: ["0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C".lowercased()])
			.sink { completed in
				switch completed {
				case .finished:
					print("Accounts received successfully")
				case let .failure(error):
					print("Error getting accounts:\(error)")
				}
			} receiveValue: { accounts in
				print("Active accounts: \(accounts)")
			}.store(in: &cancellables)

		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
			self.accounts = [
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
			completion()
		}
	}

	public func findMoreAccounts(completion: @escaping () -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
			completion()
			let avatar = Avatar.randAvatar()
			self.accounts!.append(ActiveAccountViewModel(
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
