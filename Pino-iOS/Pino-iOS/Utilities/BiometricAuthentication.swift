//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/14/23.
//

import Foundation
import LocalAuthentication
import UIKit

class AuthenticationLockViewController: UIViewController {
	// MARK: - Public Methods

	public func unlockApp(onSuccess: @escaping () -> Void) {
		let lockMethod = getLockMethod()

		switch lockMethod {
		case .face_id:
			unlockWithBiometric {
				onSuccess()
			}
		case .passcode:
			unlockWithPasscode {
				onSuccess()
			}
		}
	}

	// MARK: - Private Methods

	private func getLockMethod() -> LockMethodType {
		let defaultLockMethod = LockMethodType.face_id
		let savedLockMethod = UserDefaults.standard.string(forKey: "lockMethodType") ?? defaultLockMethod.rawValue
		let lockMethod = LockMethodType(rawValue: savedLockMethod) ?? defaultLockMethod
		return lockMethod
	}

	private func unlockWithBiometric(onSuccess: @escaping () -> Void) {
		var biometricAuthentication = BiometricAuthentication()
		biometricAuthentication.evaluate(
			onSuccess: {
				onSuccess()
			},
			onFailure: { errorCode in
				switch errorCode {
				case LAError.userFallback.rawValue:
					self.unlockWithPasscode {
						onSuccess()
					}
				case LAError.userCancel.rawValue:
					print("User cancel authentication")
				default:
					self.showFailureAlert()
				}
			}
		)
	}

	private func unlockWithPasscode(onSuccess: @escaping () -> Void) {
		let unlockAppVC = UnlockAppViewController(
			onSuccessUnlock: {
				onSuccess()
				self.dismiss(animated: true)
			},
			onFaceIDFallback: {
				self.unlockWithBiometric {
					onSuccess()
					self.dismiss(animated: true)
				}
			}
		)
		unlockAppVC.modalPresentationStyle = .fullScreen
		present(unlockAppVC, animated: true)
	}

	private func showFailureAlert() {
		let alertVC = AlertHelper.alertController(
			title: "Warning!",
			message: "There was a problem. Please try again",
			actions: [.gotIt()]
		)
		present(alertVC, animated: true)
	}
}

extension AuthenticationLockViewController {
	struct BiometricAuthentication {
		// MARK: - Private Properties

		private let laContext = LAContext()
		private let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
		private var localizedReason = "Unlock device"
		private var error: NSError?

		// MARK: - Public Methods

		public mutating func evaluate(onSuccess: @escaping () -> Void, onFailure: @escaping (Int) -> Void) {
			if canEvaluate() {
				laContext.evaluatePolicy(
					biometricsPolicy,
					localizedReason: localizedReason,
					reply: { isSuccess, error in
						DispatchQueue.main.async {
							if isSuccess {
								onSuccess()
							} else {
								guard let error else { return }
								onFailure(error._code)
							}
						}
					}
				)
			} else {
				onFailure(LAError.authenticationFailed.rawValue)
			}
		}

		// MARK: - Private Methods

		private mutating func canEvaluate() -> Bool {
			guard laContext.canEvaluatePolicy(biometricsPolicy, error: &error) else {
				return false
			}
			return true
		}
	}
}
