//
//  VerifySecretPhraseViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//

struct VerifySecretPhraseViewModel {
	// MARK: Public Properties

	public let title = "Verify secret phrase"
	public let description = "Please select each word in the correct order to verify you have saved your Secret Phrase."
	public let errorTitle = "Invalid Secret Phrase"
	public let errorIcon = "exclamationmark.circle.fill"
	public let continueButtonTitle = "Continue"
	public let pageTitle = "Verify secret phrase"
	public let userSecretPhraseList: [String]
	public let randomSecretPhraseList: [String]

	// MARK: Initializers

	init(_ secretPhrase: [String]) {
		self.userSecretPhraseList = secretPhrase
		self.randomSecretPhraseList = secretPhrase.shuffled()
	}
}
