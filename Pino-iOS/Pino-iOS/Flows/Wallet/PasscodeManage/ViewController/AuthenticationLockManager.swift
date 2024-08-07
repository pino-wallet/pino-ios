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
	private var biometricAuthentication = BiometricAuthentication()

	init(parentController: UIViewController) {
		self.parentVC = parentController
	}

	// MARK: - Public Methods

	public func unlockApp(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
		if UIDevice.current.isSimulator || Environment.current != .mainNet {
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
		let savedLockMethod: LockMethodType.RawValue = UserDefaultsManager.lockMethodType
			.getValue() ?? defaultLockMethod
			.rawValue
		let lockMethod = LockMethodType(rawValue: savedLockMethod) ?? defaultLockMethod
		return lockMethod
	}

	private func openAppSettings() {
		guard let url = URL(string: UIApplication.openSettingsURLString),
		      UIApplication.shared.canOpenURL(url)
		else {
			return
		}
		DispatchQueue.main.async {
			UIApplication.shared.open(url)
		}
	}

	private func unlockWithBiometric(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
		biometricAuthentication.evaluate(
			onSuccess: {
				self.parentVC.dismiss(animated: true) {
					onSuccess()
				}
			},
			onFailure: { errorCode in
				switch errorCode {
				case LAError.userFallback.rawValue:
					self.unlockWithPasscode(onSuccess: onSuccess, onFailure: onFailure)
				case LAError.userCancel.rawValue:
					print("User cancel authentication")
					onFailure()
				case LAError.biometryNotAvailable.rawValue:
					print("Biometeric authentication is not available on this device")
					onFailure()
				case LAError.authenticationFailed.rawValue:
					print("Authentication was not successful because user failed to provide valid credentials")
					self.unlockWithPasscode(onSuccess: onSuccess, onFailure: onFailure)
				default:
					print("Error in AUTH \(errorCode)")
					self.openAppSettings()
				}
			}
		)
	}

	private func unlockWithPasscode(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
		unlockAppVC = UnlockAppViewController(
			onSuccessUnlock: {
				self.parentVC.dismiss(animated: true) {
					onSuccess()
				}
			},
			onFaceIDSelected: {
				self.unlockWithBiometric {
					self.parentVC.dismiss(animated: true) {
						onSuccess()
					}
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
		UserDefaultsManager.lockMethodType.setValue(value: type.rawValue)
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

	private var laContext = LAContext()
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
}
