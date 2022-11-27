//
//  CreatePassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Combine
import Foundation

struct SelectPassVM: PasscodeManagerPages {
	let title = "Create passcode"
	let description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
	var passcode: String?
	var finishPassCreation: (String) -> Void
	var onErrorHandling: (PassSelectionError) -> Void

	mutating func passInserted(passChar: String) {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptySelectedPasscode)
			return
		}
		guard enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPass()
	}

	func verifyPass() {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptySelectedPasscode)
			return
		}
		if enteredPass.count == passDigitsCount {
			finishPassCreation(passcode!)
		}
	}
}
