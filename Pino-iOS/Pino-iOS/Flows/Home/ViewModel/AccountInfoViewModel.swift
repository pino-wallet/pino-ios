//
//  WalletInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

import CoreData

public struct AccountInfoViewModel: Equatable {
	// MARK: - Public Properties

	public var walletAccountInfoModel: WalletAccount!

	public var id: NSManagedObjectID {
		walletAccountInfoModel.objectID
	}

	public var name: String {
		walletAccountInfoModel.name
	}

	public var address: String {
		walletAccountInfoModel.eip55Address
	}

	public var profileImage: String {
		walletAccountInfoModel.avatarIcon
	}

	public var profileColor: String {
		walletAccountInfoModel.avatarColor
	}

	public var balance: String {
        walletAccountInfoModel.lastBalance
	}

	public var isSelected: Bool {
		walletAccountInfoModel.isSelected
	}
}
