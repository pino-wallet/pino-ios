//
//  NotifcationManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Combine
import Firebase
import FirebaseMessaging
import Foundation
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, ObservableObject {
	// MARK: - Public Properties

	public static let shared = PushNotificationManager()

	// MARK: - Private Properties

	private let accountinClient = AccountingAPIClient()
	private let walletManager = PinoWalletManager()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initiliazers

	override init() {
		super.init()
		Messaging.messaging().delegate = self // 1
	}

	// MARK: - Public Methds

	public func requestAuthorization(completionHandler: @escaping () -> Void) {
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

	public func fetchFCMToken(completion: @escaping (String) -> Void) {
		Messaging.messaging().token { token, error in
			if let error = error {
				print("Error fetching FCM registration token: \(error)")
			} else if let token = token {
				print("FCM registration token: \(token)")
				FCMTokenManager.shared.currentToken = token
				completion(token)
			}
		}
	}

	public func registerUserFCMToken(token: String, userAddress: String?) {
		guard UserDefaultsManager.isUserLoggedIn.getValue() ?? false else { return }
		let userAdd = userAddress ?? walletManager.currentAccount.eip55Address
		accountinClient.registerDeviceToken(fcmToken: token, userAdd: userAdd).sink { completed in
			switch completed {
			case .finished:
				print("Info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { resp in
			if resp.success {
				FCMTokenManager.shared.currentToken = token
			}
		}.store(in: &cancellables)
	}
}

extension PushNotificationManager: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		guard let fcmToken = fcmToken else { return }
		if let currentToken = FCMTokenManager.shared.currentToken {
			if currentToken != fcmToken {
				registerUserFCMToken(token: fcmToken, userAddress: nil)
			}
		} else {
			registerUserFCMToken(token: fcmToken, userAddress: nil)
		}
	}
}
