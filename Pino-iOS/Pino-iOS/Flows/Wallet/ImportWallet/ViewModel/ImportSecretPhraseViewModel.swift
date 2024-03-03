//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

struct ImportSecretPhraseViewModel {
	// MARK: - Public Properties

	public var title = "Import secret phrase"
	public var description = "Typically 12 words separated by single spaces"
	public var textViewPlaceholder = "Secret phrase"
	public var errorTitle = "Invalid Secret Phrase"
	public let pasteButtonTitle = "Paste"
	public let errorIcon = "exclamationmark.circle.fill"
	public let continueButtonTitle = "Import"
	public let pageTitle = "Import new wallet"

	public var maxSeedPhraseCount = HDWallet.validSeedPhraseCounts[0]

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()

	// MARK: Public Methods

	public func validate(
		secretPhrase: String,
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (SecretPhraseValidationError) -> Void
	) {
		if pinoWalletManager.isMnemonicsValid(secretPhrase) {
			onSuccess()
		} else {
			onFailure(.invalidSecretPhrase)
		}
	}

	public func trimmedMnemonic(_ input: String) -> String {
		let words = input.lowercased().components(separatedBy: .whitespacesAndNewlines)
		let trimmedWords = words.filter { !$0.isEmpty }
		return trimmedWords.joined(separator: " ")
	}
}
