//
//  SecurityLockViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/14/23.
//

import Foundation
import LocalAuthentication
import UIKit

class AuthenticationLockManager {
	// MARK: - Private Properties

	private var unlockAppVC: UnlockAppViewController?
	private var parentVC: UIViewController!

	init(parentController: UIViewController) {
		self.parentVC = parentController
	}

	// MARK: - Public Methods

	public func unlockApp(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
		if UIDevice.current.isSimulator || Environment.current != .mainNet {
			onSuccess()
			return
		} else {
			onSuccess()
			return
		}

		switch getLockMethod() {
		case .face_id:
			unlockWithBiometric(onSuccess: onSuccess, onFailure: onFailure)
		case .passcode:
			unlockWithPasscode(onSuccess: onSuccess, onFailure: onFailure)
		}
	}

	// MARK: - Private Methods

	private func getLockMethod() -> LockMethodType {
		let defaultLockMethod = LockMethodType.passcode
		let savedLockMethod = UserDefaults.standard.string(forKey: "lockMethodType") ?? defaultLockMethod.rawValue
		let lockMethod = LockMethodType(rawValue: savedLockMethod) ?? defaultLockMethod
		return lockMethod
	}

	private func unlockWithBiometric(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
		var biometricAuthentication = BiometricAuthentication()
		biometricAuthentication.evaluate(
			onSuccess: {
				onSuccess()
			},
			onFailure: { errorCode in
				switch errorCode {
				case LAError.userFallback.rawValue:
					self.unlockWithPasscode(onSuccess: onSuccess, onFailure: onFailure)
				case LAError.userCancel.rawValue:
					print("User cancel authentication")
					onFailure()
				default:
					print("Error in AUTH \(errorCode)")
					onFailure()
				}
			}
		)
	}

	private func unlockWithPasscode(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
		unlockAppVC = UnlockAppViewController(
			onSuccessUnlock: {
				onSuccess()
				self.parentVC.dismiss(animated: true)
			},
			onFaceIDSelected: {
				self.unlockWithBiometric {
					onSuccess()
					self.parentVC.dismiss(animated: true)
				} onFailure: { [self] in
					(unlockAppVC!.view as! UnlockPasscodeView).biometricsAuthFailed()
					onFailure()
				}
			}
		)
		unlockAppVC!.modalPresentationStyle = .overFullScreen
		parentVC.present(unlockAppVC!, animated: true)
	}

	private func setLockType(_ type: LockMethodType) {
		UserDefaults.standard.set(type.rawValue, forKey: "lockMethodType")
	}

	private func showFailureAlert() {
		let alertVC = AlertHelper.alertController(
			title: "Warning!",
			message: "There was a problem. Please try again",
			actions: [.gotIt()]
		)
		parentVC.present(alertVC, animated: true)
	}
}

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

	static func biometricType() -> BiometricType {
		let authContext = LAContext()
		let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
		switch authContext.biometryType {
		case .none:
			return .none
		case .touchID:
			return .touch
		case .faceID:
			return .face
		case .opticID:
			return .none
		@unknown default:
			return .none
		}
	}

	enum BiometricType {
		case none
		case touch
		case face
	}

	// MARK: - Private Methods

	private mutating func canEvaluate() -> Bool {
		guard laContext.canEvaluatePolicy(biometricsPolicy, error: &error) else {
			return false
		}
		return true
	}

	private func showAuthPrompt(onSuccess: @escaping () -> Void, onFailure: @escaping (Int) -> Void) {
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
	}
}
