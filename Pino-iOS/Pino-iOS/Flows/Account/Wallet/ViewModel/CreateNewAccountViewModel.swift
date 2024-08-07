//
//  CreateNewAccountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/20/24.
//

import Foundation

class CreateNewAccountViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Create wallet"
	public let createButtonTitle = "Create"
	public var signDescriptionText =
		"By tapping on create, you sign an off-chain message that activates this account in Pino."
	public var signDescriptionBoldText = "create"
	public let newAvatarButtonTitle = "Set new avatar"
	public let accountNamePlaceHolder = "Enter name"

	public let accounts: [AccountInfoViewModel]
	@Published
	public var accountNameValidationStatus: AccountNameValidationStatus
	@Published
	public var accountAvatar: Avatar!
	public var accountName: String!

	init(accounts: [AccountInfoViewModel]) {
		self.accounts = accounts
		self.accountNameValidationStatus = .isValid
		setupDefaultAvatar()
	}

	// MARK: - Public Methods

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
