//
//  CoreDataManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

class CoreDataManager {
	// MARK: - Private Properties

	private var accountDataSource = AccountDataSource()
	private var selectedAssetDataSource = SelectedAssetsDataSource()

	// MARK: - Public Methods

	public func getAllWallets() -> [WalletAccount] {
		accountDataSource.getAll()
	}

	public func getWallet(byId id: String) -> WalletAccount? {
		accountDataSource.get(byId: id)
	}

	@discardableResult
	public func createWallet(
		address: String,
		name: String,
		avatarIcon: String,
		avatarColor: String,
		isSelected: Bool = true
	) -> WalletAccount {
		let newAccount = WalletAccount(context: accountDataSource.managedContext)
		newAccount.eip55Address = address
		newAccount.publicKey = ""
		newAccount.derivationPath = ""
		newAccount.name = name
		newAccount.avatarIcon = avatarIcon
		newAccount.avatarColor = avatarColor
		newAccount.isSelected = isSelected
		accountDataSource.save(newAccount)
		accountDataSource.updateSelected(newAccount)
		return newAccount
	}

	public func editWallet(_ account: WalletAccount, newName: String) -> WalletAccount {
		account.name = newName
		accountDataSource.save(account)
		return account
	}

	public func editWallet(_ account: WalletAccount, newAvatar: String) -> WalletAccount {
		account.avatarIcon = newAvatar
		account.avatarColor = newAvatar
		accountDataSource.save(account)
		return account
	}

	public func deleteWallet(_ account: WalletAccount) {
		accountDataSource.delete(account)
	}

	public func updateSelectedWallet(_ account: WalletAccount) {
		accountDataSource.updateSelected(account)
	}
}
