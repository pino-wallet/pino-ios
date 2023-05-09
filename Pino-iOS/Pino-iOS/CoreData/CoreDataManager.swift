//
//  CoreDataManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

class CoreDataManager {
	// MARK: - Private Properties

	private var walletDataSource = WalletDataSource()
	private var selectedAssetDataSource = SelectedAssetsDataSource()

	// MARK: - Public Methods

	public func getAllWallets() -> [Wallet] {
		walletDataSource.getAll()
	}

	public func getWallet(byId id: String) -> Wallet? {
		walletDataSource.get(byId: id)
	}

    @discardableResult
	public func createWallet(
		id: String,
		address: String,
		name: String,
		avatarIcon: String,
		avatarColor: String,
		isSelected: Bool = true
	) -> Wallet {
		let newWallet = Wallet(context: walletDataSource.managedContext)
		newWallet.id = id
		newWallet.address = address
		newWallet.name = name
		newWallet.avatarIcon = avatarIcon
		newWallet.avatarColor = avatarColor
		newWallet.isSelected = isSelected
		walletDataSource.save(newWallet)
		walletDataSource.updateSelected(newWallet)
		return newWallet
	}

	public func editWallet(_ wallet: Wallet, newName: String) -> Wallet {
		wallet.name = newName
		walletDataSource.save(wallet)
		return wallet
	}

	public func editWallet(_ wallet: Wallet, newAvatar: String) -> Wallet {
		wallet.avatarIcon = newAvatar
		wallet.avatarColor = newAvatar
		walletDataSource.save(wallet)
		return wallet
	}

	public func deleteWallet(_ wallet: Wallet) {
		walletDataSource.delete(wallet)
	}

	public func updateSelectedWallet(_ wallet: Wallet) {
		walletDataSource.updateSelected(wallet)
	}
}
