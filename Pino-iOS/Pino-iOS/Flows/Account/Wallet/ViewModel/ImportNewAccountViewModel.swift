//
//  ImportNewAccountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/3/24.
//

import Combine

class ImportNewAccountViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Import wallet"
	public var pageDeescription =
		"By tapping on Import, you sign an off-chain message that activates this account in Pino."
	public var textViewDescription = "Typically 64 charecters"
	public var textViewPlaceholder = "Private Key"
	public var InvalidTitle = "Invalid Private Key"
	public let pasteButtonTitle = "Paste"
	public let continueButtonTitle = "Import"
	public let newAvatarButtonTitle = "Set new avatar"

	@Published
	public var validationStatus: ValidationStatus = .normal
	@Published
	public var accountAvatar = Avatar.avocado
	@Published
	public var accountName = Avatar.avocado.name

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

extension ImportNewAccountViewModel {
	public enum ValidationStatus: Equatable {
		case error
		case success
		case normal
		case loading
	}
}
