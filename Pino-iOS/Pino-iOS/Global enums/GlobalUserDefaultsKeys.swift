//
//  GlobalUserDefaulsKeys.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/29/24.
//

import Foundation

enum GlobalUserDefaultsKeys: String {
	case hasShownNotifPage
	case isInDevMode
	case showBiometricCounts
	case recentSentAddresses
	case isLogin
	case fcmToken
	case lockMethodType
	case gasLimits

	public var key: String {
		rawValue
	}
}
