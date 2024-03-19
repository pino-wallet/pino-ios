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
		PushNotificationManager.shared.requestAuthorization {
			if let fcmToken = FCMTokenManager.shared.currentToken {
				let walletManager = PinoWalletManager()
				walletManager.accounts.forEach { account in
					PushNotificationManager.shared.registerUserFCMToken(
						token: fcmToken,
						userAddress: account.eip55Address
					)
				}
			}
		}
	}
}
