//
//  NotifcationManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import FirebaseMessaging
import Foundation
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, ObservableObject {
	static let shared = PushNotificationManager()

	override init() {
		super.init()
		Messaging.messaging().delegate = self // 1
	}

	func requestAuthorization(completionHandler: @escaping () -> Void) {
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().getNotificationSettings { settings in // 2
			switch settings.authorizationStatus {
			case .denied:
				guard let url = URL(string: UIApplication.openSettingsURLString),
				      UIApplication.shared.canOpenURL(url)
				else {
					return
				}
				DispatchQueue.main.async {
					UIApplication.shared.open(url) // 3
					completionHandler()
				}
			case .notDetermined:
				UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in // 4
					guard granted else { return completionHandler() }
					DispatchQueue.main.async {
						completionHandler()
					}
				}
			case .authorized:
				DispatchQueue.main.async {
					completionHandler() // 5
				}
			case .provisional, .ephemeral:
				completionHandler()
			@unknown default:
				completionHandler()
			}
		}
	}
}

extension PushNotificationManager: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		guard let fcmToken = fcmToken else { return }
		FCMTokenManager.shared.currentToken = fcmToken // 6
	}
}
