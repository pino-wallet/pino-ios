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
	public var signDescriptionText =
		"By tapping on import, you sign an off-chain message that activates this account in Pino."
	public var signDescriptionBoldText = "import"
	public var textViewDescription = "Typically 64 alphanumeric characters"
	public var textViewPlaceholder = "Private Key"
	public let pasteButtonTitle = "Paste"
	public let continueButtonTitle = "Import"
	public let newAvatarButtonTitle = "Set new avatar"
	public let accountNamePlaceHolder = "Enter name"
	public var accounts: [AccountInfoViewModel]

	@Published
	public var accountAvatar: Avatar!
	public var accountName: String!

	@Published
	public var privateKeyValidationStatus: PrivateKeyValidationStatus
	@Published
	public var accountNameValidationStatus: AccountNameValidationStatus

	// MARK: - Private Properties

	private let pinoWalletManager = PinoWalletManager()
	private let coreDataManager = CoreDataManager()

	// MARK: - Initializers

	init(accounts: [AccountInfoViewModel]) {
		self.accounts = accounts
		self.privateKeyValidationStatus = .isEmpty
		self.accountNameValidationStatus = .isValid
		setupDefaultAvatar()
	}

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
			privateKeyValidationStatus = .isEmpty
			return
		}
		if pinoWalletManager.isPrivatekeyValid(privateKey) {
			privateKeyValidationStatus = .isValid
		} else {
			privateKeyValidationStatus = .invalidKey
		}
	}

	public func validateAccountName(_ newAccountName: String) {
		if newAccountName.trimmingCharacters(in: .whitespaces).isEmpty {
			accountNameValidationStatus = .isEmpty
			return
		}

		if accounts.contains(where: { $0.name == newAccountName }) {
			accountNameValidationStatus = .duplicateName
		} else {
			accountNameValidationStatus = .isValid
		}
	}

	public func isAccountNameValid() -> Bool {
		validateAccountName(accountName)
		if accountNameValidationStatus == .isValid {
			return true
		} else {
			return false
		}
	}

	// MARK: Private Methods

	private func setupDefaultAvatar() {
		let userAvatars = accounts.map { $0.profileImage }
		let defaultAvatar = Avatar.randAvatar(userAvatars: userAvatars)
		accountAvatar = defaultAvatar
		accountName = defaultAvatar.name
	}
}
