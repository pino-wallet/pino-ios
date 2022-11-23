//
//  VerifyPassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

enum PassSaveError: Error {}

enum PassVerifyError: Error {
	case notTheSame
	case saveFailed
	case unknown
}

struct VerifyPassVM: PasscodeManagerPages {
	var title = "Retype passcode"
	var description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
	var passcode = ""
	var finishPassCreation: () -> Void
	var onErrorHandling: ((PassVerifyError) -> Void)?
	var selectedPasscode: String

	mutating func passInserted(passChar: String) {
		guard passcode.count < passDigitsCount else { return }
		passcode.append(passChar)
		verifyPasscode()
	}

	func verifyPasscode() {
		if passcode.count == passDigitsCount {
			if passcode == selectedPasscode {
				// pass storation succeeds
				finishPassCreation()
				savePasscodeInKeychain()
			} else {
				onErrorHandling!(.notTheSame)
			}
		}
	}

	func savePasscodeInKeychain() {
		let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())
		do {
			try keychainHelper.store(passcode)
		} catch PassVerifyError.saveFailed {
			onErrorHandling!(.saveFailed)
		} catch {
			onErrorHandling!(.unknown)
		}
	}
}
