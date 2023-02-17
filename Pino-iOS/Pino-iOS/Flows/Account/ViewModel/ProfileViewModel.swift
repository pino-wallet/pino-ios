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

	// MARK: - Initializers

	init(walletInfo: WalletInfoViewModel) {
		self.walletInfo = walletInfo
		setupSettings()
	}

	// MARK: - Private Methods

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
