//
//  CreatePassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct SelectPassViewModel: PasscodeManagerPages {
	// MARK: Public Properties

	public let title = "Create PIN"
	public let description: String? =
		"Set a PIN to enhance your wallet security."
	public var passcode: String?
	public var finishPassCreation: (String) -> Void
	public var onErrorHandling: (PassSelectionError) -> Void

	// MARK: Public Methods

	public mutating func passInserted(passChar: String) {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptySelectedPasscode)
			return
		}
		guard enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPass()
	}

	public func verifyPass() {
		guard let enteredPass = passcode else {
			onErrorHandling(.emptySelectedPasscode)
			return
		}
		if enteredPass.count == passDigitsCount {
			finishPassCreation(passcode!)
		}
	}
}
