//
//  VerifyPassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

enum PassSaveError: Error {
	case notTheSame
	case saveFailed
}

enum PassVerifyError: Error {
    
}

struct VerifyPassVM: PasscodeManagerPages {
	var title = "Retype passcode"
	var description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
	var passcode = ""
	var finishPassCreation: () -> Void
	let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())
	var error = DynamicValue<PassError?>(nil)

	mutating func passInserted(passChar: String) {
		guard passcode.count < passDigitsCount else { return }
		passcode.append(passChar)
		if passcode.count == passDigitsCount {
			if let createdPasscode = keychainHelper.retrievePasscode() {
				if createdPasscode == passcode {
					// pass storation succeeds
					finishPassCreation()
				} else {
					error.value = .notTheSame
				}
			} else {
				// Probably the app should crash Or return user back to prev page to create again
				fatalError("Password retrieval failed")
			}
		}
	}
}
