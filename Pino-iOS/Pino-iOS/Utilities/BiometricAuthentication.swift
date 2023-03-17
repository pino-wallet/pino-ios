//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/14/23.
//

import LocalAuthentication

struct BiometricAuthentication {
	private let laContext = LAContext()
	private let biometricsPolicy = LAPolicy.deviceOwnerAuthentication
	private var localizedReason = "Unlock device"
	private var error: NSError?

	public mutating func evaluate(onSuccess: @escaping () -> Void) {
		if canEvaluate() {
			laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { isSuccess, error in
				DispatchQueue.main.async {
					if isSuccess {
						onSuccess()
					} else {
						#warning("Talk to designer about handling failed auth")
						print(error?.localizedDescription ?? "Authentication failed")
					}
				}
			})
		} else {
			fatalError("Auth evaluation failed")
		}
	}

	private mutating func canEvaluate() -> Bool {
		guard laContext.canEvaluatePolicy(biometricsPolicy, error: &error) else {
			return false
		}
		return true
	}
}
