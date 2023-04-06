//
//  CreatePassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct SelectPassViewModel: PasscodeManagerPages {
	// MARK: Public Properties

	public let title = "Create passcode"
	public let description: String? =
		"This passcode is for maximizing wallet security. It cannot be used to recover it."
	public var passcode: String?
	public var finishPassCreation: (String) -> Void
	public var onErrorHandling: (PassSelectionError) -> Void
	public let faceIdTitle: String? = nil
	public let useFaceIdTitle: String? = nil
	public let useFaceIdIcon: String? = nil

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
