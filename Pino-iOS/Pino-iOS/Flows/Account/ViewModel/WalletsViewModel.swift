//
//  WalletViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine

class WalletsViewModel {
	// MARK: - Public Properties

	public var walletsList: [WalletInfoViewModel]!

	// MARK: - Private Properties

	private var walletAPIClient = WalletAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init() {
		getWallets()
	}

	// MARK: - Private Methods

	private func getWallets() {
		// Request to get wallet info
		walletsList =
			[WalletInfoViewModel(walletInfoModel: WalletInfoModel(
				name: "Amir",
				address: "",
				profileImage: "avocado",
				profileColor: "Green color 2"
			))]
	}
}
