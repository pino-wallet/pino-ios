//
//  VerifyPassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct VerifyPassVM: PasscodeManagerPages {
	let title = "Retype passcode"
	let description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
	var passcode: String? = ""
	var finishPassCreation: () -> Void
	var onErrorHandling: (PassVerifyError) -> Void
	var selectedPasscode: String

	mutating func passInserted(passChar: String) {
		guard let enteredPass = passcode, enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPasscode()
	}

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
