//
//  NotificationViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/10/23.
//

import Foundation
import UIKit

class NotificationSettingsViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Notifications"
	public let notificationOptionsSectionTitle = "Options"
	@Published
	public var isNotifAllowed: Bool = UserDefaultsManager.allowNotif.getValue()!

	// MARK: - Private Properties

	private let allowNotifVM = AllowNotificationsViewModel()

	// MARK: - Public Methods

	public func getNotifOptions() -> [NotificationOptionModel] {
		let isActivityNotifOn = UserDefaultsManager.allowActivityNotif.getValue() ?? false
		let isPinoNotifOn = UserDefaultsManager.allowPinoUpdateNotif.getValue() ?? false

		let walletActivityNotif = NotificationOptionModel(
			title: "Wallet activity",
			type: .wallet_activity,
			isSelected: isActivityNotifOn,
			description: "Send, swap, borrow, and more."
		)
		let pinoUpdateNotif = NotificationOptionModel(
			title: "Pino update",
			type: .pino_update,
			isSelected: isPinoNotifOn,
			description: "Feature announcements and update"
		)

		return [walletActivityNotif, pinoUpdateNotif]
	}

	public func getGeneralNotifOptions() -> [NotificationOptionModel] {
		var isNotifOn = false

		if let allowNotif = UserDefaultsManager.allowNotif.getValue() {
			if allowNotif {
				isNotifOn = true
			} else {
				isNotifOn = false
			}
		}

		let notifOption = NotificationOptionModel(
			title: "Allow notification",
			type: .allow_notification,
			isSelected: isNotifOn,
			description: nil
		)

		return [notifOption]
	}

	public func saveNotifSettings(isOn: Bool, notifType: NotificationOptionModel.NotificationOption) {
		PushNotificationManager.shared.requestAuthorization { granted in
			guard granted else { return }
			switch notifType {
			case .wallet_activity:
				UserDefaultsManager.allowActivityNotif.setValue(value: isOn)
				self.toggleNotifActivation(isOn)
			case .pino_update:
				UserDefaultsManager.allowPinoUpdateNotif.setValue(value: isOn)
			case .liquidation_notice:
				break
			case .allow_notification:
				UserDefaultsManager.allowNotif.setValue(value: isOn)
				self.isNotifAllowed = isOn
				self.toggleNotifActivation(isOn)
			}
		}
	}

	// MARK: - Private Methods

	private func toggleNotifActivation(_ isOn: Bool) {
		if isOn {
			allowNotifVM.activateNotifs()
		} else {
			PushNotificationManager.shared.deactivateNotifs()
		}
	}
}
