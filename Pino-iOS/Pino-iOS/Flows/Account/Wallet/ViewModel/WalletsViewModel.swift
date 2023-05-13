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

    private var accountingAPIClient = AccountingAPIClient()
	private var walletAPIClient = WalletAPIMockClient()
	private var cancellables = Set<AnyCancellable>()
	private let coreDataManager = CoreDataManager()

	// MARK: - Initializers

	init() {
		getAccounts()
	}

	// MARK: - Public Methods

	public func getAccounts() {
		// Request to get wallets
		let wallets = coreDataManager.getAllWalletAccounts()
		walletsList = wallets.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
	}
    
    public func activateNewAccountAddress(_ address: String) {
        accountingAPIClient.activateAccountWith(address: address)
            .retry(3)
            .sink(receiveCompletion: { completed in
                switch completed {
                case .finished:
                    print("Wallet activated")
                case let .failure(error):
                    print(error)
                }
            }) { activatedAccount in
                self.addNewWalletWithAddress(address)
            }.store(in: &cancellables)
    }

	private func addNewWalletWithAddress(_ address: String) {
        let wallet = coreDataManager.getAllWallets().first(where: { $0.accountSource == .nonHDWallet })
		let avatar = Avatar.allCases.randomElement() ?? .green_apple

		coreDataManager.createWalletAccount(
			address: address,
			name: avatar.name,
			avatarIcon: avatar.rawValue,
			avatarColor: avatar.rawValue,
            wallet: wallet!
		)
		getAccounts()
	}

	public func editWallet(wallet: WalletInfoViewModel, newName: String) -> WalletInfoViewModel {
		let edittedWallet = coreDataManager.editWalletAccount(wallet.walletInfoModel, newName: newName)
		getAccounts()
		return WalletInfoViewModel(walletInfoModel: edittedWallet)
	}

	public func editWallet(wallet: WalletInfoViewModel, newAvatar: String) -> WalletInfoViewModel {
		let edittedWallet = coreDataManager.editWalletAccount(wallet.walletInfoModel, newAvatar: newAvatar)
		getAccounts()
		return WalletInfoViewModel(walletInfoModel: edittedWallet)
	}

	public func removeWallet(_ walletVM: WalletInfoViewModel) {
		coreDataManager.deleteWalletAccount(walletVM.walletInfoModel)
		getAccounts()
	}

	public func updateSelectedWallet(with selectedWallet: WalletInfoViewModel) {
		coreDataManager.updateSelectedWalletAccount(selectedWallet.walletInfoModel)
		getAccounts()
	}
}
