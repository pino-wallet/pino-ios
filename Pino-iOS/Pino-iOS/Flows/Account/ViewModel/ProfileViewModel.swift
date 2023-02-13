//
//  ProfileViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import Combine

class ProfileViewModel {
	// MARK: - Public Properties

	public var walletInfo: WalletInfoViewModel!
	public var accountSettings: [SettingsViewModel]!
	public var generalSettings: [SettingsViewModel]!

	// MARK: - Private Properties

	private var walletAPIClient = WalletAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init() {
		getWalletInfo()
		setupSettings()
	}

	// MARK: - Private Methods

	private func getWalletInfo() {
		// Request to get wallet info
		walletAPIClient.walletInfo().sink { completed in
			switch completed {
			case .finished:
				print("Wallet info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { walletInfo in
			self.walletInfo = WalletInfoViewModel(walletInfoModel: walletInfo)
		}.store(in: &cancellables)
	}

	private func setupSettings() {
		accountSettings = [.wallets]
		generalSettings = [
			.currency,
			.notification,
			.securityLock,
			.recoverPhrase,
			.support,
			.aboutPino,
		]
	}
}
