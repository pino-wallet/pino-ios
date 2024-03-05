//
//  ActiveAccountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Foundation

public struct ActiveAccountViewModel: Equatable {
	// MARK: - Private Properties

	private let avatar = Avatar.randAvatar()

	// MARK: - Public Properties

	public let account: Account

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

	public var derivationPath: String {
		account.derivationPath!
	}

	public var publicKey: String {
		account.publicKey.hex()
	}

	public var isSelected: Bool
	public var isNewWallet: Bool
	public var balance: String

	// MARK: - Initializers

	init(account: Account, balance: String, isNewWallet: Bool = false) {
		self.account = account
		self.balance = balance
		self.isNewWallet = isNewWallet
		if isNewWallet {
			self.isSelected = true
		} else {
			self.isSelected = false
		}
	}

	// MARK: - Public Methods

	public mutating func toggleIsSelected() {
		isSelected.toggle()
	}
}
