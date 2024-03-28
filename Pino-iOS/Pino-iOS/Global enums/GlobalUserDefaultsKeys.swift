//
//  Global.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/27/24.
//

import Foundation

public enum GlobalUserDefaultsKeys: String {
    case hasShownNotifPage
    case isInDevMode
    case showBiometricCounts
    case recentSentAddresses
    case isLogin
    case fcmToken
    case lockMethodType
    case gasLimits
    case syncFinishTime
    case securityModes
    case pinoUpdateNotif
    case activityNotif
    case allowNotif

    public var key: String {
        rawValue
    }
}
