//
//  VerifyPassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct VerifyPassViewModel: PasscodeManagerPages {
	// MARK: Public Properties

	public let title = "Confirm PIN"
	public let description: String? =
		"Set a PIN to enhance your wallet security."
	public let errorTitle = "Incorrect, try again!"
	public var passcode: String? = ""
	public var finishPassCreation: () -> Void
	public var onErrorHandling: (PassVerifyError) -> Void
	public var hideError: () -> Void
	public var selectedPasscode: String
	public var selectedAccounts: [ActiveAccountViewModel]?

	// MARK: - Public Methods

	public mutating func passInserted(passChar: String) {
		guard let enteredPass = passcode, enteredPass.count < passDigitsCount else { return }
		passcode?.append(passChar)
		verifyPasscode()
	}

	public func showSyncPage() -> Bool {
		guard let selectedAccounts else { return false }
		if let firstAccount = selectedAccounts.first, firstAccount.isNewWallet {
			return false
		}
		return true
	}

	// MARK: - Private Methods

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
