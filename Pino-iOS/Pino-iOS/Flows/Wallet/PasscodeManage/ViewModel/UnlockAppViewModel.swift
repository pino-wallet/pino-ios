//
//  EnterPasscodeViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/5/23.
//

struct UnlockAppViewModel: UnlockPasscodePageManager {
	// MARK: - Public Properties

	public let title = "Enter your passcode"
	public let description: String? = nil
	public let faceIdTitle: String? = "Unlock with face id"
	public let useFaceIdTitle: String? = "Use face ID"
	public let useFaceIdIcon: String? = "face_id_small"
	public var passcode: String? = ""
	public let dontMatchErrorText = "Incorrect, try again!"

	// MARK: - Closures

	public var onClearError: () -> Void
	public var onErrorHandling: ((UnlockAppError) -> Void)!
	public var onSuccessUnlock: () -> Void

	// MARK: - Public Methods

	public mutating func passInserted(passChar: String) {
		guard let enteredPass = passcode, enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPasscode()
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
