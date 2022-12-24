//
//  WalletInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

struct WalletInfoViewModel {
	// MARK: - Public Properties

	public var walletInfoModel: WalletInfoModel!

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
}
