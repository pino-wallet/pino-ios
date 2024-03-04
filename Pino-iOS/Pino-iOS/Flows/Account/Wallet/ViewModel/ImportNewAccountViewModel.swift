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
	public var textViewDescription = "Typically 64 alphanumeric characters"
	public var textViewPlaceholder = "Private Key"
	public var InvalidTitle = "Invalid Private Key"
	public let pasteButtonTitle = "Paste"
	public let continueButtonTitle = "Import"
	public let newAvatarButtonTitle = "Set new avatar"
	public let accountNamePlaceHolder = "Enter name"

	@Published
	public var accountAvatar = Avatar.avocado
	public var accountName = Avatar.avocado.name

	@Published
	public var validationStatus: ValidationStatus = .empty

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private let coreDataManager = CoreDataManager()

	// MARK: Public Methods

	public func validateWalletAccount(
		privateKey: String,
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (ImportValidationError) -> Void
	) {
		if pinoWalletManager.isPrivatekeyValid(privateKey) {
			onSuccess()
		} else {
			onFailure(.invalidPrivateKey)
		}
	}

	public func validatePrivateKey(_ privateKey: String) {
		guard privateKey != .emptyString else {
			validationStatus = .empty
			return
		}
		if pinoWalletManager.isPrivatekeyValid(privateKey) {
			validationStatus = .validKey
		} else {
			validationStatus = .invalidKey
		}
	}
}

extension ImportNewAccountViewModel {
	public enum ValidationStatus: Equatable {
		case empty
		case validKey
		case invalidKey
		case invalidAccount
	}
}
