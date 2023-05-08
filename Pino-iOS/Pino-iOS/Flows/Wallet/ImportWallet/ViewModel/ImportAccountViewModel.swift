//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

struct ImportAccountViewModel {
	// MARK: - Public Properties

	public var title: String {
		if isNewWallet {
			return "Import secret phrase"
		} else {
			return "Import private key"
		}
	}

	public var description: String {
		if isNewWallet {
			return "Typically 12 words separated by single spaces"
		} else {
			return "Typically 64 charecters"
		}
	}

	public var textViewPlaceholder: String {
		if isNewWallet {
			return "Secret phrase"
		} else {
			return "Private Key"
		}
	}

	public let pasteButtonTitle = "Paste"
	public let errorTitle = "Invalid Secret Phrase"
	public let errorIcon = "exclamationmark.circle.fill"
	public let continueButtonTitle = "Import"
	public let pageTitle = "Import new wallet"

	public var maxSeedPhraseCount = HDWallet.validSeedPhraseCounts[0]

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private var isNewWallet: Bool

	init(isNewWallet: Bool) {
		self.isNewWallet = isNewWallet
	}

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

	public func validate(
		privateKey: String,
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (SecretPhraseValidationError) -> Void
	) {
		if pinoWalletManager.isPrivatekeyValid(privateKey) {
			onSuccess()
		} else {
			onFailure(.invalidSecretPhrase)
		}
	}
}
