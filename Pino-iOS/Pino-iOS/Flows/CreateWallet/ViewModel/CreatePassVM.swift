//
//  CreatePassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct CreatePassVM: PasscodeManagerPages {
	var title = "Create passcode"
	var description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
	var passcode = ""
	var finishPassCreation: () -> Void
	let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())

	mutating func passInserted(passChar: String) {
		guard passcode.count < passDigitsCount else { return }
		passcode.append(passChar)
		if passcode.count == passDigitsCount {
			if keychainHelper.store(passcode) {
				// pass storation succeeds
				finishPassCreation()
			} else {
				// Pass Storation Fails
				// In case keychain is disabled or there is a criticial issue
				// We should show an error to user
				fatalError("Passcode was not stored in keychain")
			}
		}
	}

	func resetPassword() {
		if !keychainHelper.resetPasscode() {
			fatalError("Passcode in Keychain was not deleted")
		}
	}
}
