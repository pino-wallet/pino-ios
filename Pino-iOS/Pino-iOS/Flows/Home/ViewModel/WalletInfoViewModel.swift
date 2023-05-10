//
//  WalletInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

import CoreData

public struct WalletInfoViewModel: Equatable {
	// MARK: - Public Properties

	public var walletInfoModel: WalletAccount!

	public var id: NSManagedObjectID {
		walletInfoModel.objectID
	}

	public var name: String {
		walletInfoModel.name
	}

	public var address: String {
		walletInfoModel.eip55Address
	}

	public var profileImage: String {
		walletInfoModel.avatarIcon
	}

	public var profileColor: String {
		walletInfoModel.avatarColor
	}

	public var balance: String {
		"$0"
	}

	public var isSelected: Bool {
		walletInfoModel.isSelected
	}
}
