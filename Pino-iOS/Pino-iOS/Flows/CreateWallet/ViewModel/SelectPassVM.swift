//
//  CreatePassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Combine
import Foundation

struct SelectPassVM: PasscodeManagerPages {
	var title = "Create passcode"
	var description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
	var passcode = ""
	var finishPassCreation: (String) -> Void
	var onErrorHandling: (PassSelectionError) -> Void

	mutating func passInserted(passChar: String) {
		guard passcode.count < passDigitsCount else { return }
		passcode.append(passChar)
		verifyPass()
	}

	func verifyPass() {
		if passcode.count == passDigitsCount {
			finishPassCreation(passcode)
		}
	}
}
