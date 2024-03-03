//
//  ImportNewAccountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/3/24.
//

struct ImportNewAccountViewModel {
	// MARK: - Public Properties

	public var title = "Import private key"
	public var description = "Typically 64 charecters"
	public var textViewPlaceholder = "Private Key"
	public var errorTitle = "Invalid Private Key"
	public let pasteButtonTitle = "Paste"
	public let errorIcon = "exclamationmark.circle.fill"
	public let continueButtonTitle = "Import"
	public let pageTitle = "Import new wallet"

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private let coreDataManager = CoreDataManager()

	// MARK: Public Methods

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
