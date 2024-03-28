//
//  NotifcationManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Combine
import FirebaseCore
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

	public func requestAuthorization(grantedAuth: @escaping (Bool) -> Void) {
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
					grantedAuth(false)
				}
			case .notDetermined:
				UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in // 4
					guard granted else { return grantedAuth(false) }
					DispatchQueue.main.async {
						grantedAuth(true)
					}
				}
			case .authorized:
				DispatchQueue.main.async {
					grantedAuth(true)
				}
			case .provisional, .ephemeral:
				grantedAuth(true)
			@unknown default:
				grantedAuth(true)
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

	public func deactivateNotifs() {
		if let token = FCMTokenManager.shared.currentToken {
			removeUserToken(token)
		} else {
			fetchFCMToken { token in
				self.removeUserToken(token)
			}
		}
	}

	// MARK: - Private Methds

	private func removeUserToken(_ token: String) {
		accountinClient.removeDeviceToken(fcmToken: token).sink { _ in
		} receiveValue: { resp in
			if resp.success {
				UserDefaultsManager.allowNotif.setValue(value: false)
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
