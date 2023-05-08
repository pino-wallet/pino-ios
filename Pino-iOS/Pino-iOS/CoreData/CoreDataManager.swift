//
//  CoreDataManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

class DataManager {
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

	public func saveWallet(_ wallet: Wallet) {
		walletDataSource.save(wallet)
	}

	public func deleteWallet(_ wallet: Wallet) {
		walletDataSource.delete(wallet)
	}

	public func getAllSelectedAssets() -> [SelectedAsset] {
		selectedAssetDataSource.getAll()
	}

	public func saveSelectedAsset(_ asset: SelectedAsset) {
		selectedAssetDataSource.save(asset)
	}

	public func deleteSelectedAsset(_ asset: SelectedAsset) {
		selectedAssetDataSource.delete(asset)
	}
}
