//
//  EnterPasscodeViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/5/23.
//

import Foundation

class UnlockAppViewModel: UnlockPasscodePageManager {
	// MARK: - Public Properties

	public let title = "Enter your passcode"
	public let description: String? = nil
	public let faceIdTitle: String? = "Unlock with face id"
	public let useFaceIdTitle: String? = "Use face ID"
	public var passcode: String? = ""
	public let dontMatchErrorText = "Incorrect, try again!"
	public var lockMethodType: LockMethodType {
		get {
			let savedLockMethod = UserDefaults.standard.string(forKey: "lockMethodType") ?? LockMethodType.passcode
				.rawValue
			let lockMethod = LockMethodType(rawValue: savedLockMethod) ?? LockMethodType.passcode
			return lockMethod
		}
		set {
			UserDefaults.standard.setValue(newValue.rawValue, forKey: "lockMethodType")
		}
	}

	public var useBiometricIcon: String? {
		switch BiometricAuthentication.biometricType() {
		case .face:
			return "face_id_small"
		case .touch:
			return "touchid"
		case .none:
			return nil
		}
	}

	public var useBiometricTitle: String? {
		switch BiometricAuthentication.biometricType() {
		case .face:
			return "Unlock with Face ID"
		case .touch:
			return "Unlock with Touch ID"
		case .none:
			return nil
		}
	}

	// MARK: - Closures

	public var onClearError: () -> Void
	public var onErrorHandling: ((UnlockAppError) -> Void)!
	public var onSuccessUnlock: () -> Void

	init(
		passcode: String? = "",
		onClearError: @escaping () -> Void,
		onErrorHandling: ((UnlockAppError) -> Void)!,
		onSuccessUnlock: @escaping () -> Void
	) {
		self.passcode = passcode
		self.onClearError = onClearError
		self.onErrorHandling = onErrorHandling
		self.onSuccessUnlock = onSuccessUnlock
	}

	// MARK: - Public Methods

	public func passInserted(passChar: String) {
		guard let enteredPass = passcode, enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPasscode()
	}

	public func setLockType(_ type: LockMethodType) {
		lockMethodType = type
	}

	// MARK: - Private Methods

	private func verifyPasscode() {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptyPasscode)
			return
		}
		if !enteredPass.isEmpty {
			onClearError()
		}
		if enteredPass.count == passDigitsCount {
			let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())
			let currentPasscode = keychainHelper.retrievePasscode()
			guard let currentPasscode else {
				onErrorHandling(.getPasswordFailed)
				return
			}
			if currentPasscode == enteredPass {
				onSuccessUnlock()
			} else {
				onErrorHandling(.dontMatch)
			}
		}
	}
}
