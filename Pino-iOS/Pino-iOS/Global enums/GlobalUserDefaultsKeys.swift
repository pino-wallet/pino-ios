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
		}
	}
}
