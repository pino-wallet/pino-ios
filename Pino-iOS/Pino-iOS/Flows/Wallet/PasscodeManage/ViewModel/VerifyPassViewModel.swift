//
//  VerifyPassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct VerifyPassViewModel: PasscodeManagerPages {
	// MARK: Public Properties

	public let title = "Retype passcode"
	public let description: String? =
		"This passcode is for maximizing wallet security. It cannot be used to recover it."
	public let errorTitle = "Incorrect, try again!"
	public var passcode: String? = ""
	public var finishPassCreation: () -> Void
	public var onErrorHandling: (PassVerifyError) -> Void
	public var hideError: () -> Void
	public var selectedPasscode: String

	// MARK: Public Methods

	public mutating func passInserted(passChar: String) {
		guard let enteredPass = passcode, enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPasscode()
	}

	// MARK: Private Methods

	private func verifyPasscode() {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptyPasscode)
			return
		}
		if enteredPass.count == passDigitsCount {
			if passcode == selectedPasscode {
				// pass storation succeeds
				finishPassCreation()
				savePasscodeInKeychain()
			} else {
				onErrorHandling(.dontMatch)
			}
		}
		if enteredPass.count == 1 {
			hideError()
		}
	}

	private func savePasscodeInKeychain() {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptyPasscode)
			return
		}
		let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())
		do {
			try keychainHelper.store(enteredPass)
		} catch PassVerifyError.saveFailed {
			onErrorHandling(.saveFailed)
		} catch {
			onErrorHandling(.unknown)
		}
	}
}
