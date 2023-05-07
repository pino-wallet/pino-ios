//
//  WalletViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine
import Foundation

class WalletsViewModel {
	// MARK: - Public Properties

	@Published
	public var walletsList: [WalletInfoViewModel]!

	// MARK: - Private Properties

	private var walletAPIClient = WalletAPIMockClient()
	private var cancellables = Set<AnyCancellable>()
	private let walletManager = WalletManager()

	// MARK: - Initializers

	init() {
		getWallets()
	}

	// MARK: - Public Methods

	public func updateSelectedWallet(with selectedWallet: WalletInfoModel) {
		let wallets = walletManager.setSelectedState(wallet: selectedWallet)
		walletsList = wallets.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
	}

	public func editWallet(newWallet: WalletInfoModel) {
		let wallets = walletManager.editWallet(newWallet: newWallet)
		walletsList = wallets.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
	}

	public func removeWallet(_ wallet: WalletInfoModel) {
		let wallets = walletManager.removeWallet(wallet: wallet)
		walletsList = wallets.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
	}

	public func getWallets() {
		// Request to get wallets
		let wallets = walletManager.getWalletsFromUserDefaults()
		walletsList = wallets.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
	}
}
