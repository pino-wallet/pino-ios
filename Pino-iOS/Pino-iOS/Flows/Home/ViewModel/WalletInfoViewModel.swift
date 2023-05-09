//
//  WalletInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

public struct WalletInfoViewModel: Equatable {
	// MARK: - Public Properties

	public var walletInfoModel: Wallet!

	public var id: String {
		walletInfoModel.id!
	}

	public var name: String {
		walletInfoModel.name!
	}

	public var address: String {
		walletInfoModel.address!
	}

	public var profileImage: String {
		walletInfoModel.avatarIcon!
	}

	public var profileColor: String {
		walletInfoModel.avatarColor!
	}

	public var balance: String {
		"$0"
	}

	public var isSelected: Bool {
		walletInfoModel.isSelected
	}
}
