//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/14/23.
//

import LocalAuthentication

class BiometricAuthentication {
	private static let laContext = LAContext()
	private static var error: NSError?
	private static let biometricsPolicy = LAPolicy.deviceOwnerAuthentication
	private static var localizedReason = "Unlock device"

	public static func evaluate(onSuccess: @escaping () -> Void) {
		if canEvaluate() {
			setLocalizedReason()
			laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { isSuccess, error in
				DispatchQueue.main.async {
					if isSuccess {
						onSuccess()
					} else {
						fatalError(error?.localizedDescription ?? "Authentication failed")
					}
				}
			})
		}
	}

	private static func canEvaluate() -> Bool {
		guard laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
			// Maps error to our BiometricError
			return false
		}
		// Context can evaluate the Policy
		return true
	}

	private static func setLocalizedReason() {
		if laContext.biometryType == LABiometryType.faceID {
			localizedReason = "Unlock using Face ID"
		} else if laContext.biometryType == LABiometryType.touchID {
			localizedReason = "Unlock using Touch ID"
		} else {
			print("No Biometric support")
		}
	}
}
