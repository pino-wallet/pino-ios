//
//  FCMTokenManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Foundation

class FCMTokenManager {
	// MARK: - Public Properties

	public static let shared = FCMTokenManager()

	public var currentToken: String? {
		get {
			UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken.rawValue)
		}

		set {
			UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.fcmToken.rawValue)
		}
	}

	// MARK: - Private Properties

	private enum UserDefaultKey: String {
		case fcmToken
	}
}
