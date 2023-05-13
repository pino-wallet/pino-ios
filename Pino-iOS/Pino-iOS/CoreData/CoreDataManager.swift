//
//  CoreDataManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

class CoreDataManager {
	// MARK: - Private Properties

    private var walletDataSource = WalletDataSource()
	private var accountDataSource = AccountDataSource()
	private var selectedAssetDataSource = SelectedAssetsDataSource()

	// MARK: - Public Methods
    
    public func getAllWallets() -> [Wallet] {
        walletDataSource.getAll()
    }
    
    public func createWallet(type: Wallet.AccountSource, lastDrivedIndex: Int32 = 0) -> Wallet {
        let newWallet = Wallet(context: walletDataSource.managedContext)
        newWallet.accountSource = type
        newWallet.lastDrivedIndex = lastDrivedIndex
        walletDataSource.save(newWallet)
        return newWallet
    }

	public func getAllWalletAccounts() -> [WalletAccount] {
		accountDataSource.getAll()
	}

	public func getWalletAccount(byId id: String) -> WalletAccount? {
		accountDataSource.get(byId: id)
	}

	@discardableResult
	public func createWalletAccount(
		address: String,
		name: String,
		avatarIcon: String,
		avatarColor: String,
		isSelected: Bool = true,
        wallet: Wallet
	) -> WalletAccount {
		let newAccount = WalletAccount(context: accountDataSource.managedContext)
		newAccount.eip55Address = address
        newAccount.publicKey = .empty
		newAccount.derivationPath = ""
		newAccount.name = name
		newAccount.avatarIcon = avatarIcon
		newAccount.avatarColor = avatarColor
		newAccount.isSelected = isSelected
        newAccount.wallet = wallet
        newAccount.wallet.lastDrivedIndex += 1
		accountDataSource.save(newAccount)
		accountDataSource.updateSelected(newAccount)
		return newAccount
	}

	public func editWalletAccount(_ account: WalletAccount, newName: String) -> WalletAccount {
		account.name = newName
		accountDataSource.save(account)
		return account
	}

	public func editWalletAccount(_ account: WalletAccount, newAvatar: String) -> WalletAccount {
		account.avatarIcon = newAvatar
		account.avatarColor = newAvatar
		accountDataSource.save(account)
		return account
	}

	public func deleteWalletAccount(_ account: WalletAccount) {
		accountDataSource.delete(account)
	}

	public func updateSelectedWalletAccount(_ account: WalletAccount) {
		accountDataSource.updateSelected(account)
	}
}
