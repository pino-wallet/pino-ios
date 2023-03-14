//
//  BiometricError.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/14/23.
//

import Foundation

enum BiometricError: LocalizedError {
	case authenticationFailed
	case userCancel
	case userFallback
	case biometryNotAvailable
	case biometryNotEnrolled
	case biometryLockout
	case unknown

	var errorDescription: String? {
		switch self {
		case .authenticationFailed: return "There was a problem verifying your identity."
		case .userCancel: return "You pressed cancel."
		case .userFallback: return "You pressed password."
		case .biometryNotAvailable: return "Face ID/Touch ID is not available."
		case .biometryNotEnrolled: return "Face ID/Touch ID is not set up."
		case .biometryLockout: return "Face ID/Touch ID is locked."
		case .unknown: return "Face ID/Touch ID may not be configured"
		}
	}
}
