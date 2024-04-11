//
//  RecoveryPhraseViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

struct RecoveryPhraseViewModel {
	// MARK: Public Properties

	public let title = "Keep it safe"
	public let description = "Do not share your phrase with anyone, as it gives them full access to your wallet."
	public let copyButtonTitle = "Copy to clipboard"
	public let copyButtonIcon = "square.on.square"
	public let warningDescription = "The Pino team will NEVER ask for your secret phrase"
	public let screenshotAlertTitle = "Warning"
	public let screenshotAlertMessage = "It isn't safe to take a screenshot of a secret phrase!"
	public var revealButtonTitle = "Tap to reveal"
	public var secretPhraseList: [String] = []

	// MARK: Initializers

	private let pinoWalletManager = PinoWalletManager()

	init() {
		getSecretPhrase()
	}

	// MARK: - Private Methods

	private mutating func getSecretPhrase() {
		secretPhraseList = pinoWalletManager.exportMnemonics().array
	}
}
