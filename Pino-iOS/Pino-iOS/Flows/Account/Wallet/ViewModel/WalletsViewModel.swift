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
	private let coreDataManager = CoreDataManager()

	// MARK: - Initializers

	init() {
		getWallets()
	}

	// MARK: - Public Methods

	public func getWallets() {
		// Request to get wallets
		let wallets = coreDataManager.getAllWallets()
		walletsList = wallets.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
	}

	public func addNewWalletWithAddress(_ address: String) {
		let wallets = coreDataManager.getAllWallets()
		let lastWalletId = wallets.last?.id ?? "0"
		let newWalletId = (Int(lastWalletId) ?? 0) + 1
		let avatar = Avatar.allCases.randomElement() ?? .green_apple

		coreDataManager.createWallet(
			id: String(newWalletId),
			address: address,
			name: avatar.name,
			avatarIcon: avatar.rawValue,
			avatarColor: avatar.rawValue
		)
		getWallets()
	}

	public func editWallet(wallet: WalletInfoViewModel, newName: String) -> WalletInfoViewModel {
		let edittedWallet = coreDataManager.EditWallet(wallet.walletInfoModel, newName: newName)
		getWallets()
		return WalletInfoViewModel(walletInfoModel: edittedWallet)
	}

	public func editWallet(wallet: WalletInfoViewModel, newAvatar: String) -> WalletInfoViewModel {
		let edittedWallet = coreDataManager.EditWallet(wallet.walletInfoModel, newAvatar: newAvatar)
		getWallets()
		return WalletInfoViewModel(walletInfoModel: edittedWallet)
	}

	public func removeWallet(_ walletVM: WalletInfoViewModel) {
		coreDataManager.deleteWallet(walletVM.walletInfoModel)
		getWallets()
	}

	public func updateSelectedWallet(with selectedWallet: WalletInfoViewModel) {
		coreDataManager.updateSelectedWallet(selectedWallet.walletInfoModel)
		getWallets()
	}
}
