//
//  CoreDataManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//
import Foundation

class CoreDataManager {
	// MARK: - Private Properties

	private var walletDataSource = WalletDataSource()
	private var accountDataSource = AccountDataSource()
	private var selectedAssetDataSource = SelectedAssetsDataSource()
	private var customAssetsDataSource = CustomAssetDataSource()
    private var activityDataSource = ActivityDataSource()

	// MARK: - Public Methods

	public func getAllWallets() -> [Wallet] {
		walletDataSource.getAll()
	}

	public func getSelectedWalletOf(type: Wallet.WalletType) -> Wallet? {
		walletDataSource.get(byType: type)
	}

	@discardableResult
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

	public func getWalletAccountsOfType(walletType: Wallet.WalletType) -> [WalletAccount] {
		accountDataSource.get(byWalletType: walletType)
	}

	@discardableResult
	public func createWalletAccount(
		address: String,
		derivationPath: String? = nil,
		publicKey: String,
		name: String,
		avatarIcon: String,
		avatarColor: String,
		isSelected: Bool = true,
		wallet: Wallet
	) -> WalletAccount {
		let newAccount = WalletAccount(context: accountDataSource.managedContext)
		newAccount.eip55Address = address
		newAccount.publicKey = publicKey
		newAccount.derivationPath = derivationPath
		newAccount.name = name
		newAccount.avatarIcon = avatarIcon
		newAccount.avatarColor = avatarColor
		newAccount.isSelected = isSelected
		newAccount.wallet = wallet
		newAccount.selectedAssets = []
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

	@discardableResult
	public func editWalletAccount(_ account: WalletAccount, lastBalance: String) -> WalletAccount {
		account.lastBalance = lastBalance
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

	public func getAllSelectedAssets() -> [SelectedAsset] {
		selectedAssetDataSource.getAll()
	}

	public func addNewSelectedAsset(id: String) -> SelectedAsset {
		let newSelectedAsset = SelectedAsset(context: selectedAssetDataSource.managedContext)
		newSelectedAsset.id = id
		newSelectedAsset.account = PinoWalletManager().currentAccount
		selectedAssetDataSource.save(newSelectedAsset)
		return newSelectedAsset
	}

	public func deleteSelectedAsset(_ selectedAsset: SelectedAsset) {
		selectedAssetDataSource.delete(selectedAsset)
	}

	public func getAllCustomAssets() -> [CustomAsset] {
		customAssetsDataSource.getAll()
	}

	public func addNewCustomAsset(id: String, symbol: String, name: String, decimal: String) -> CustomAsset {
		let newCustomAsset = CustomAsset(context: customAssetsDataSource.managedContext)
		newCustomAsset.id = id.lowercased()
		newCustomAsset.symbol = symbol
		newCustomAsset.name = name
		newCustomAsset.decimal = decimal
		customAssetsDataSource.save(newCustomAsset)
		return newCustomAsset
	}
    
    @discardableResult
    public func addNewSwapActivity(activityModel: ActivitySwapModel) -> CoreDataSwapActivity {
        let newActivity = CoreDataSwapActivity(context: activityDataSource.managedContext)
        
        newActivity.txHash = activityModel.txHash
        newActivity.type = activityModel.type
        newActivity.fromAddress = activityModel.fromAddress
        newActivity.toAddress = activityModel.toAddress
        newActivity.blockTime = activityModel.blockTime
        newActivity.gasUsed = activityModel.gasUsed
        newActivity.gasPrice = activityModel.gasPrice
        
        
        let newActivityDetails = CoreDataSwapActivityDetails(context: activityDataSource.managedContext)
        
        newActivityDetails.userID = activityModel.detail?.userID
        newActivityDetails.activityProtool = activityModel.detail?.activityProtocol
        
        let newActivityDetailsFromToken = CoreDataSwapActivityDetailsFromToken(context: activityDataSource.managedContext)
        
        newActivityDetailsFromToken.amount = activityModel.detail?.fromToken?.amount
        newActivityDetailsFromToken.tokenId = activityModel.detail?.fromToken?.tokenID
        newActivityDetails.from_token = newActivityDetailsFromToken
        
        let newActivityDetailsToToken = CoreDataSwapActivityDetailsToToken(context: activityDataSource.managedContext)
        
        newActivityDetailsToToken.amount = activityModel.detail?.toToken?.amount
        newActivityDetailsToToken.tokenId = activityModel.detail?.toToken?.tokenID
        newActivityDetails.to_token = newActivityDetailsToToken
        
        
        newActivity.details = newActivityDetails
        
        activityDataSource.save(newActivity)
        return newActivity
    }
    
    @discardableResult
    public func addNewTransferActivity(activityModel: ActivityTransferModel) -> CoreDataTransferActivity {
        let newActivity = CoreDataTransferActivity(context: activityDataSource.managedContext)
        
        newActivity.txHash = activityModel.txHash
        newActivity.type = activityModel.type
        newActivity.fromAddress = activityModel.fromAddress
        newActivity.toAddress = activityModel.toAddress
        newActivity.blockTime = activityModel.blockTime
        newActivity.gasUsed = activityModel.gasUsed
        newActivity.gasPrice = activityModel.gasPrice
        
        let newActivityDetails = CoreDataTransferActivityDetails(context: activityDataSource.managedContext)
        
        newActivityDetails.amount = activityModel.detail?.amount
        newActivityDetails.tokenID = activityModel.detail?.tokenID
        newActivityDetails.from = activityModel.detail?.from
        newActivityDetails.to = activityModel.detail?.to
        
        newActivity.details = newActivityDetails
        
        activityDataSource.save(newActivity)
        return newActivity
    }
    
    public func getAllActivities() -> [CoreDataActivityParent] {
        activityDataSource.getAll()
    }
    
    public func deleteActivityByID(_ id: String) {
        activityDataSource.deleteByID(id)
    }
    
}
