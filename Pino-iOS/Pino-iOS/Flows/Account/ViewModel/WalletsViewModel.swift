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
		// Request to get wallets
		walletAPIClient.walletsList().sink { completed in
			switch completed {
			case .finished:
				print("Wallets received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { wallets in
			self.walletsList = wallets.walletsList.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
		}.store(in: &cancellables)
	}
}
