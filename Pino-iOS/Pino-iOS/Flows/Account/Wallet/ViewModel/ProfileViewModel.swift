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

	public let pageTitle = "Settings"
	public let feedbackURL = "https://forms.gle/quYfsgfZupvgE3418"
	public let dismissIconName = "dismiss"
	@Published
	public var walletInfo: AccountInfoViewModel!
	public var accountSettings: [SettingsViewModel]!
	public var generalSettings: [SettingsViewModel]!
	public var walletBalance: String?

	// MARK: - Initializers

	init(walletInfo: AccountInfoViewModel) {
		self.walletInfo = walletInfo
		setupSettings()
	}

	// MARK: - Private Methods

	private func setupSettings() {
		accountSettings = [.wallets]
		generalSettings = [
			.notification,
			.securityLock,
			.recoverPhrase,
			.sendFeedback,
			.aboutPino,
		]
	}
}
