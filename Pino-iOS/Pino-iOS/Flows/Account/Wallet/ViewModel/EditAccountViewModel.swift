//
//  EditAccountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//

class EditAccountViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Edit account"
	public let changeAvatarTitle = "Set new avatar"
	public let doneButtonText = "Done"
	public let removeAccountButtonText = "Remove account"
	public let removeAccountButtonTitle = "Remove account"

	public let editAccountOptions = [
		EditAccountOptionModel(title: "Wallet name", type: .name, rightIconName: "arrow_right"),
		EditAccountOptionModel(title: "Show private key", type: .private_key, rightIconName: "arrow_right"),
	]
}
