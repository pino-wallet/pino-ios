//
//  GlobalUserDefaulsKeys.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/29/24.
//

import Foundation

enum GlobalUserDefaultsKeys {
	case hasShownNotifPage
	case isInDevMode
	case showBiometricCounts
	case recentSentAddresses
	case isLogin
	case fcmToken
	case lockMethodType

	public var key: String {
		switch self {
		case .hasShownNotifPage:
			"hasShownNotifPage"
		case .isInDevMode:
			"isInDevMode"
		case .showBiometricCounts:
			"showBiometricCounts"
		case .recentSentAddresses:
			"recentSentAddresses"
		case .isLogin:
			"isLogin"
		case .fcmToken:
			"fcmToken"
		case .lockMethodType:
			"lockMethodType"
		}
	}
}
