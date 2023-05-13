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
    
    public func getSelectedWalletOf(type: Wallet.WalletType) -> Wallet? {
        walletDataSource.get(byType: type)
    }
    
    public func createWallet(type: Wallet.WalletType, lastDrivedIndex: Int32 = 0) -> Wallet {
        let newWallet = Wallet(context: walletDataSource.managedContext)
        newWallet.walletType = type
        newWallet.isSelected = true
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
    
    public func getWalletAccountsOfType(walletType:Wallet.WalletType) -> [WalletAccount] {
        accountDataSource.get(byWalletType: walletType)
    }

	@discardableResult
	public func createWalletAccount(
		address: String,
        derivationPath: String? = nil,
		name: String,
		avatarIcon: String,
		avatarColor: String,
		isSelected: Bool = true,
        wallet: Wallet
	) -> WalletAccount {
		let newAccount = WalletAccount(context: accountDataSource.managedContext)
		newAccount.eip55Address = address
        newAccount.publicKey = .empty
		newAccount.derivationPath = derivationPath
		newAccount.name = name
		newAccount.avatarIcon = avatarIcon
		newAccount.avatarColor = avatarColor
		newAccount.isSelected = isSelected
        newAccount.wallet = wallet
        if newAccount.wallet.walletType == .hdWallet {
            newAccount.wallet.lastDrivedIndex += 1
        }
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
