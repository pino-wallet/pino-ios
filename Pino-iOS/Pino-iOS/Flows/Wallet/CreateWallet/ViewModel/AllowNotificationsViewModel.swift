//
//  AllowNotificationsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/15/23.
//

import Combine
import Foundation

class AllowNotificationsViewModel {
	// MARK: - Public Properties

	public let headerIcon = "green_alert"
	public let titleText = "Turn on notification"
	public let descriptionText = "Get instant notifications whenever an event occurs on your wallet."
	public let enableNotificationsButtonTitleText = "Enable notification"
	public let skipButtonTitleText = "Skip"
	public let sampleNotificationCardImage1 = "sample_notification_1"
	public let sampleNotificationCardImage2 = "sample_notification_2"
	public let navbarDismissImageName = "close"

	// MARK: - Private Properties

	// MARK: - Public Properties

	public func enableNotifications() {
		// enable notifications here...
		PushNotificationManager.shared.requestAuthorization { granted in
			UserDefaultsManager.allowNotif.setValue(value: granted)
			UserDefaultsManager.allowPinoUpdateNotif.setValue(value: granted)
			UserDefaultsManager.allowActivityNotif.setValue(value: granted)
			if granted {
				self.activateNotifs()
			}
		}
	}

	public func skipActivatingNotif() {
		UserDefaultsManager.allowNotif.setValue(value: false)
		UserDefaultsManager.allowPinoUpdateNotif.setValue(value: false)
		UserDefaultsManager.allowActivityNotif.setValue(value: false)
	}

	public func activateNotifs() {
		if let fcmToken = FCMTokenManager.shared.currentToken {
			activateAccountsWith(token: fcmToken)
		} else {
			PushNotificationManager.shared.fetchFCMToken { fcmToken in
				self.activateAccountsWith(token: fcmToken)
			}
		}
	}

	// MARK: - Private Methods

	private func activateAccountsWith(token: String) {
		let walletManager = PinoWalletManager()
		walletManager.accounts.forEach { account in
			PushNotificationManager.shared.registerUserFCMToken(
				token: token,
				userAddress: account.eip55Address
			)
		}
	}
}
