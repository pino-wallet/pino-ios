//
//  SecretPhraseVM.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

import UIKit

struct ShowSecretPhraseViewModel {
	// MARK: Public Properties

	public let title = "Backup secret phrase"
	public let firstDescription = "Write down your Secret Phrase and store it in a safe place."
	public let secondDescription = "It allows you to recover your wallet if you lose your device or password"
	public let revealButtonTitle = "Tap to reveal"
	public let shareButtonTitle = "Copy"
	public let shareButtonIcon = UIImage(systemName: "square.on.square")
	public let continueButtonTitle = "I saved"
	public let screenshotAlertTitle = "Warning"
	public let screenshotAlertMessage = "It isn't safe to take a screenshot of a secret phrase!"
	public var secretPhraseList: [String] = []

	// MARK: - Privare Properties

	private let emptyPassphrase = ""

	// MARK: Initializers

	init() {
		generateMnemonic()
	}

	// MARK: - Private Methods

	private mutating func generateMnemonic() {
		let seedPhraseCount = SeedPhraseCount.word12
		if let newHdWallet = HDWallet(strength: seedPhraseCount.strength, passphrase: emptyPassphrase) {
			let mnemonic = newHdWallet.mnemonic
			secretPhraseList = mnemonic.toArray
		} else {
			fatalError("ganerate mnemonic faild.")
		}
	}
}
