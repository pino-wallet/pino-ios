//
//  ProfileViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import Combine
import Foundation

class ProfileViewModel {
	// MARK: - Public Properties

	@Published
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
		if let selectedWallet = getSelectedWalletFromUserDefault() {
			walletInfo = selectedWallet
		} else {
			walletAPIClient.walletsList().sink { completed in
				switch completed {
				case .finished:
					print("Wallet info received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { wallets in
				guard let firstWallet = wallets.walletsList.first else { fatalError("No wallet found") }
				self.walletInfo = WalletInfoViewModel(walletInfoModel: firstWallet)
			}.store(in: &cancellables)
		}
	}

	private func getSelectedWalletFromUserDefault() -> WalletInfoViewModel? {
		guard let encodedWallet = UserDefaults.standard.data(forKey: "selectedWallet") else { return nil }
		do {
			let walletModel = try JSONDecoder().decode(WalletInfoModel.self, from: encodedWallet)
			return WalletInfoViewModel(walletInfoModel: walletModel)
		} catch {
			return nil
		}
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
