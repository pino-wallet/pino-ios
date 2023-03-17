//
//  RecoveryPhraseViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

struct RecoveryPhraseViewModel {
	// MARK: Public Properties

	public let title = "Your secret phease"
	public let description = "A two line description should be here. A two line description should be here"
	public let copyButtonTitle = "Copy to clipboard"
	public let copyButtonIcon = "square.on.square"
	public let warningTitle = "DO NOT share your phrase with anyone as this gives full access to your wallet!"
	public let warningDescription = "Pino support will NEVER reach out to ask for it!"
	public let screenshotAlertTitle = "Warning"
	public let screenshotAlertMessage = "It isn't safe to take a screenshot of a secret phrase!"
	public var secretPhraseList: [String] = []

	// MARK: Initializers

	init() {
		getSecretPhrase()
	}

	// MARK: - Private Methods

	private mutating func getSecretPhrase() {
		#warning("Secret phrase is temporary and must be replaced by Keychain data")
		secretPhraseList = [
			"mask",
			"impose",
			"destroy",
			"into",
			"release",
			"planet",
			"warm",
			"token",
			"donate",
			"outside",
			"alley",
			"kidney",
		]
	}
}
