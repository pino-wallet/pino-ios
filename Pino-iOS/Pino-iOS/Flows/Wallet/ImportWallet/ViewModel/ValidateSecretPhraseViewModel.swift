//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

struct ValidateSecretPhraseViewModel {
	// MARK: Public Properties

	public let title = "Import secret phrase"
	public let description = "Typically 12 words separated by single spaces"
	public let textViewPlaceHolder = "Secret phrase"
	public let pasteButtonTitle = "Paste"
	public let errorTitle = "Invalid Secret Phrase"
	public let errorIcon = "exclamationmark.circle.fill"
	public let continueButtonTitle = "Import"
	public let pageTitle = "Import new wallet"

	public var maxSeedPhraseCount = HDWallet.validSeedPhraseCounts[0]

	// MARK: Public Methods

	public func validate(
		secretPhrase: [String],
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (SecretPhraseValidationError) -> Void
	) {
		let intersction = Array(Set(secretPhrase).intersection(HDWallet.englishWordList))
		if intersction.count == secretPhrase.count {
			onSuccess()
		} else {
			onFailure(.invalidSecretPhrase)
		}
	}
}
