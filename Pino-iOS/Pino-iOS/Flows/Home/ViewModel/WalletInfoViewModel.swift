//
//  WalletInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

public struct WalletInfoViewModel: Equatable {
	// MARK: - Public Properties

	public var walletInfoModel: WalletInfoModel!

	public var id: String {
		walletInfoModel.id
	}

	public var name: String {
		walletInfoModel.name
	}

	public var address: String {
		walletInfoModel.address
	}

	public var profileImage: String {
		walletInfoModel.profileImage
	}

	public var profileColor: String {
		walletInfoModel.profileColor
	}

	public var balance: String {
		"$\(walletInfoModel.balance)"
	}

	public var isSelected: Bool {
		walletInfoModel.isSelected
	}

	// MARK: - Public Methods

	public mutating func isSelected(_ isSelected: Bool) {
		walletInfoModel.isSelected(isSelected)
	}
}
