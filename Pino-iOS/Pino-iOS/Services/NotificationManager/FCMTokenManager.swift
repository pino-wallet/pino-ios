//
//  FCMTokenManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/12/23.
//

import Foundation

class FCMTokenManager {
    // MARK: - Private Properties
    private let userDefaultsManager = UserDefaultsManager(userDefaultKey: .fcmToken)
    
	// MARK: - Public Properties

	public static let shared = FCMTokenManager()

	public var currentToken: String? {
		get {
            userDefaultsManager.getValue()
		}

		set {
            userDefaultsManager.setValue(value: newValue)
		}
	}
	
}
