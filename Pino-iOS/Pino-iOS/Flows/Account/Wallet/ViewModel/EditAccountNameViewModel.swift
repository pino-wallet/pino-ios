//
//  EditWalletNameViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

class EditAccountNameViewModel {
	// MARK: - Closures

	public var didValidatedAccountName: (_ error: ValidateAccountNameErrorType) -> Void

	// MARK: - Public Properties

	public let pageTitle = "Wallet name"
	public let doneButtonName = "Done"
	public let accountNamePlaceHolder = "Enter name"
	public let accountNameIsRepeatedError = "Already taken!"
	public let accountNameIsEmptyError = "Cant be empty"

	public var selectedAccount: AccountInfoViewModel
	public var accounts: [AccountInfoViewModel]

	// MARK: - Initializers

	init(
		didValidatedAccountName: @escaping (_: ValidateAccountNameErrorType) -> Void,
		selectedAccount: AccountInfoViewModel,
		accounts: [AccountInfoViewModel]
	) {
		self.didValidatedAccountName = didValidatedAccountName
		self.selectedAccount = selectedAccount
		self.accounts = accounts
	}

	// MARK: - Public Methods

	public func validateAccountName(newAccountName: String) {
		if newAccountName.trimmingCharacters(in: .whitespaces).isEmpty {
			didValidatedAccountName(.isEmpty)
		} else {
			if accounts.contains(where: { $0.name == newAccountName && $0.id != selectedAccount.id }) {
				didValidatedAccountName(.repeatedName)
			} else {
				didValidatedAccountName(.clear)
			}
		}
	}
}

extension EditAccountNameViewModel {
	public enum ValidateAccountNameErrorType: Error {
		case isEmpty
		case repeatedName
		case clear
	}
}
