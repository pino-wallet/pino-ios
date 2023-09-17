//
//  ActiveAccountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Foundation

public struct ActiveAccountViewModel: Equatable {
	// MARK: - Private Properties

	private let account: Account
	private let avatar = Avatar.randAvatar()

	// MARK: - Public Properties

	public var name: String {
		avatar.name
	}

	public var address: String {
		account.eip55Address
	}

	public var profileImage: String {
		avatar.rawValue
	}

	public var profileColor: String {
		avatar.rawValue
	}

	public var balance: String {
		""
	}

	public var derivationPath: String {
		account.derivationPath!
	}

	public var publicKey: String {
		account.publicKey.hex()
	}

	public var isSelected = false

	// MARK: - Initializers

	init(account: Account) {
		self.account = account
	}

	// MARK: - Public Methods

	public mutating func toggleIsSelected() {
		isSelected.toggle()
	}
}
