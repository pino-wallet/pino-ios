//
//  FCMTokenManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Foundation

class FCMTokenManager {
	static let shared = FCMTokenManager()

	private enum UserDefaultKey: String {
		case fcmToken
	}

	var currentToken: String? {
		get {
			UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken.rawValue)
		}

		set {
			UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.fcmToken.rawValue)
		}
	}
}
