//
//  FCMTokenManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Foundation

class FCMTokenManager {
	// MARK: - Private Properties

	private let fcmTokenUserDefaultsManager = UserDefaultsManager<String>(userDefaultKey: .fcmToken)

	// MARK: - Public Properties

	public static let shared = FCMTokenManager()

	public var currentToken: String? {
		get {
			fcmTokenUserDefaultsManager.getValue()
		}
		set {
			fcmTokenUserDefaultsManager.setValue(value: newValue!)
		}
	}
}
