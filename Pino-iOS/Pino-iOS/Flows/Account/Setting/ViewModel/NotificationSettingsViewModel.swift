//
//  NotificationViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import Foundation

class NotificationSettingsViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Notifications"
	public let notificationOptionsSectionTitle = "Options"

	public let notificationOptions = [
		NotificationOptionModel(
			title: "Wallet activity",
			type: .wallet_activity,
			isSelected: true,
			description: "Send, swap, borrow, and more."
		),
		NotificationOptionModel(
			title: "Pino update",
			type: .pino_update,
			isSelected: true,
			description: "Feature announcements and update"
		),
	]
	public let generalNotificationOptions = [
		NotificationOptionModel(
			title: "Allow notification",
			type: .allow_notification,
			isSelected: true,
			description: nil
		),
	]
}
