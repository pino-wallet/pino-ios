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
	public let changeAvatarTitle = "Set new avatar"
	public let CreateButtonTitle = "Create"

	public let accounts: [AccountInfoViewModel]

	@Published
	public var accountAvatar = Avatar.avocado
	public var accountName = Avatar.avocado.name

	init(accounts: [AccountInfoViewModel]) {
		self.accounts = accounts
	}
}
