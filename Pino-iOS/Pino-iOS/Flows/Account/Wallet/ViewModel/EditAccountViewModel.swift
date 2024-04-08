//
//  EditAccountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//

import Combine

class EditAccountViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedAccount: AccountInfoViewModel

	@Published
	public var isLastAccount = false

	public let pageTitle = "Edit wallet"
	public let changeAvatarTitle = "Set new avatar"
	public let doneButtonText = "Done"
	public let removeAccountButtonText = "Remove wallet"
	public let removeAccountButtonTitle = "Remove wallet"

	public let editAccountOptions = [
		EditAccountOptionModel(title: "Wallet name", type: .name, rightIconName: "chevron_right"),
		EditAccountOptionModel(title: "Show private key", type: .private_key, rightIconName: "chevron_right"),
	]

	init(selectedAccount: AccountInfoViewModel) {
		self.selectedAccount = selectedAccount
	}
}
