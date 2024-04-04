//
//  ActiveAccountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Foundation

public struct ActiveAccountViewModel: Equatable {
	// MARK: - Private Properties

	public var avatar: Avatar!

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
	public var balance: BigNumber

	// MARK: - Initializers

	init(account: Account, balance: BigNumber?, isNewWallet: Bool = false, avatar: Avatar) {
		self.account = account
		self.balance = balance ?? 0.bigNumber
		self.isNewWallet = isNewWallet
		self.avatar = avatar
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
