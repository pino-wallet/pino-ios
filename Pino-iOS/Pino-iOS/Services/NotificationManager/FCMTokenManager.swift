//
//  FCMTokenManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Foundation

class FCMTokenManager {
	// MARK: - Private Properties

	// MARK: - Public Properties

	public static let shared = FCMTokenManager()

	public var currentToken: String? {
		get {
			UserDefaultsManager.fcmToken.getValue()
		}
		set {
			UserDefaultsManager.fcmToken.setValue(value: newValue!)
		}
	}
}
