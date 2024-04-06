//
//  SecretPhraseVM.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

struct ShowSecretPhraseViewModel {
	// MARK: Public Properties

	public let title = "Backup secret phrase"
	public let firstDescription = "Write down your Secret Phrase and store it in a safe place."
	public let secondDescription = "It allows you to recover your wallet if you lose your device or PIN."
	public let revealButtonTitle = "Tap to reveal"
	public let shareButtonTitle = "Copy"
	public let shareButtonIcon = "square.on.square"
	public let continueButtonTitle = "I saved"
    public let signDescriptionPrefixText = "By tapping on "
    public let signDescriptionBoldText = "I saved"
    public let signDescriptionSuffixText = ", you sign an off-chain message that actives this account in Pino."
	public let screenshotAlertTitle = "Warning"
	public let screenshotAlertMessage = "It isn't safe to take a screenshot of a secret phrase!"
	public let pageTitle = "Create new wallet"
	public var secretPhraseList: [String] = []

	// MARK: - Privare Properties

	private let pinoWalletManager = PinoWalletManager()

	// MARK: Initializers

	// MARK: - Private Methods

	public mutating func generateMnemonics() {
		let mnemonics = HDWallet.generateMnemonic(seedPhraseCount: .word12)
		secretPhraseList = mnemonics.split(separator: " ").map { String($0) }
	}
}
