//
//  SettingViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

public struct SettingsViewModel: Equatable {
	// MARK: - Public Properties

	public let image: String
	public let title: String
	public let description: String?
}

extension SettingsViewModel {
	// MARK: - Setting Items

	public static let wallets = SettingsViewModel(
		image: "setting_wallets",
		title: "Wallets",
		description: nil
	)
	public static let currency = SettingsViewModel(
		image: "setting_currency",
		title: "Currency",
		description: "USD -US Dollar"
	)
	public static let notification = SettingsViewModel(
		image: "setting_notification",
		title: "Notifications",
		description: nil
	)
	public static let securityLock = SettingsViewModel(
		image: "setting_security",
		title: "Security lock",
		description: nil
	)
	public static let recoverPhrase = SettingsViewModel(
		image: "setting_recovery",
		title: "Recovery phrase",
		description: nil
	)
	public static let aboutPino = SettingsViewModel(
		image: "setting_about",
		title: "About Pino",
		description: nil
	)
	public static let sendFeedback = SettingsViewModel(
		image: "feedback_settings",
		title: "Send feedback",
		description: nil
	)
}
