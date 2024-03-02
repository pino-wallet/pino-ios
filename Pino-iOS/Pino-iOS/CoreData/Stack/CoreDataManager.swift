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

	public func getWalletAccountBy(publicKey: String) -> WalletAccount? {
		accountDataSource.getBy(id: publicKey)
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
		hasDefaultAssets: Bool = false,
		wallet: Wallet
	) -> WalletAccount? {
		guard accountDataSource.getBy(id: publicKey) == nil else { return nil }
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
		newAccount.hasDefaultAssets = hasDefaultAssets
		newAccount.isPositionEnabled = false
		newAccount.createdAt = Date()
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
	public func editWalletAccount(_ account: WalletAccount, lastETHBalance: String) -> WalletAccount {
		account.lastETHBalance = lastETHBalance
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
		newSelectedAsset.account.hasDefaultAssets = true
		selectedAssetDataSource.save(newSelectedAsset)
		return newSelectedAsset
	}

	public func getSelectedAssetBy(id: String) -> SelectedAsset? {
		selectedAssetDataSource.getBy(id: id)
	}

	public func deleteSelectedAsset(_ selectedAsset: SelectedAsset) {
		selectedAssetDataSource.delete(selectedAsset)
	}

	public func enableAccountPositions(_ isPositionEnable: Bool) {
		let currentAccount = PinoWalletManager().currentAccount
		currentAccount.isPositionEnabled = isPositionEnable
		accountDataSource.save(currentAccount)
	}

	public func getAllCustomAssets() -> [CustomAsset] {
		customAssetsDataSource.getAll()
	}

	public func addNewCustomAsset(
		id: String,
		symbol: String,
		name: String,
		decimal: String,
		accountAddress: String
	) -> CustomAsset? {
		guard !customAssetsDataSource.checkForAlreadyExist(accountAddress: accountAddress, id: id) else { return nil }
		let newCustomAsset = CustomAsset(context: customAssetsDataSource.managedContext)
		newCustomAsset.id = id.lowercased()
		newCustomAsset.symbol = symbol
		newCustomAsset.name = name
		newCustomAsset.decimal = decimal
		newCustomAsset.accountAddress = accountAddress
		customAssetsDataSource.save(newCustomAsset)
		return newCustomAsset
	}

	@discardableResult
	public func addNewSwapActivity(activityModel: ActivitySwapModel, accountAddress: String) -> CDSwapActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDSwapActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDSwapActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.activityProtool = activityModel.detail.activityProtocol

		let newActivityDetailsFromToken = CDActivityDetailsToken(
			context: activityDataSource
				.managedContext
		)

		newActivityDetailsFromToken.amount = activityModel.detail.fromToken.amount
		newActivityDetailsFromToken.tokenId = activityModel.detail.fromToken.tokenID
		newActivityDetails.from_token = newActivityDetailsFromToken

		let newActivityDetailsToToken = CDActivityDetailsToken(context: activityDataSource.managedContext)

		newActivityDetailsToToken.amount = activityModel.detail.toToken.amount
		newActivityDetailsToToken.tokenId = activityModel.detail.toToken.tokenID
		newActivityDetails.to_token = newActivityDetailsToToken

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewTransferActivity(
		activityModel: ActivityTransferModel,
		accountAddress: String
	) -> CDTransferActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDTransferActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDTransferActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.amount = activityModel.detail.amount
		newActivityDetails.tokenID = activityModel.detail.tokenID
		newActivityDetails.from = activityModel.detail.from
		newActivityDetails.to = activityModel.detail.to

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewApproveActivity(
		activityModel: ActivityApproveModel,
		accountAddress: String
	) -> CDApproveActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDApproveActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDApproveActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.amount = activityModel.detail.amount
		newActivityDetails.tokenID = activityModel.detail.tokenID
		newActivityDetails.spender = activityModel.detail.spender
		newActivityDetails.owner = activityModel.detail.owner

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewInvestActivity(
		activityModel: ActivityInvestModel,
		accountAddress: String
	) -> CDInvestActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDInvestActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDInvestActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.nftID = Int64(activityModel.detail.nftId ?? 0)
		newActivityDetails.poolID = activityModel.detail.positionId
		newActivityDetails.tokens = Set(activityModel.detail.tokens.compactMap {
			let newActivityDetailsToken = CDActivityDetailsToken(context: activityDataSource.managedContext)
			newActivityDetailsToken.amount = $0.amount
			newActivityDetailsToken.tokenId = $0.tokenID
			return newActivityDetailsToken
		})
		newActivityDetails.activityProtocol = activityModel.detail.activityProtocol

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewWithdrawActivity(
		activityModel: ActivityWithdrawModel,
		accountAddress: String
	) -> CDWithdrawActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDWithdrawActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDWithdrawActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.nftID = Int64(activityModel.detail.nftId ?? 0)
		newActivityDetails.poolID = activityModel.detail.positionId
		newActivityDetails.tokens = Set(activityModel.detail.tokens.compactMap {
			let newActivityDetailsToken = CDActivityDetailsToken(context: activityDataSource.managedContext)
			newActivityDetailsToken.amount = $0.amount
			newActivityDetailsToken.tokenId = $0.tokenID
			return newActivityDetailsToken
		})
		newActivityDetails.activityProtocol = activityModel.detail.activityProtocol

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewRepayActivity(
		activityModel: ActivityRepayModel,
		accountAddress: String
	) -> CDRepayActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDRepayActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDRepayActivityDetails(context: activityDataSource.managedContext)

		let repaidToken = CDActivityDetailsToken(context: accountDataSource.managedContext)
		repaidToken.amount = activityModel.detail.repaidToken.amount
		repaidToken.tokenId = activityModel.detail.repaidToken.tokenID

		let repaidWithToken = CDActivityDetailsToken(context: accountDataSource.managedContext)
		repaidWithToken.amount = activityModel.detail.repaidWithToken.amount
		repaidWithToken.tokenId = activityModel.detail.repaidWithToken.tokenID

		newActivityDetails.repaid_token = repaidToken
		newActivityDetails.repaid_with_token = repaidWithToken
		newActivityDetails.activityProtocol = activityModel.detail.activityProtocol

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewBorrowActivity(
		activityModel: ActivityBorrowModel,
		accountAddress: String
	) -> CDBorrowActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDBorrowActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDBorrowActivityDetails(context: activityDataSource.managedContext)

		let borrowToken = CDActivityDetailsToken(context: accountDataSource.managedContext)
		borrowToken.amount = activityModel.detail.token.amount
		borrowToken.tokenId = activityModel.detail.token.tokenID

		newActivityDetails.token = borrowToken
		newActivityDetails.activityProtocol = activityModel.detail.activityProtocol

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewCollateralActivity(
		activityModel: ActivityCollateralModel,
		accountAddress: String
	) -> CDCollateralActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDCollateralActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDCollateralActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.tokens = Set(activityModel.detail.tokens.compactMap {
			let newActivityDetailsToken = CDActivityDetailsToken(context: activityDataSource.managedContext)
			newActivityDetailsToken.amount = $0.amount
			newActivityDetailsToken.tokenId = $0.tokenID
			return newActivityDetailsToken
		})
		newActivityDetails.activityProtocol = activityModel.detail.activityProtocol

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewWrapETHActivity(
		activityModel: ActivityWrapETHModel,
		accountAddress: String
	) -> CDWrapETHActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDWrapETHActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDWrapETHActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.amount = activityModel.detail.amount

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	@discardableResult
	public func addNewUnwrapETHActivity(
		activityModel: ActivityUnwrapETHModel,
		accountAddress: String
	) -> CDUnwrapETHActivity? {
		guard activityDataSource.getBy(id: activityModel.txHash) == nil else { return nil }
		let newActivity = CDUnwrapETHActivity(context: activityDataSource.managedContext)

		newActivity.txHash = activityModel.txHash
		newActivity.type = activityModel.type
		newActivity.fromAddress = activityModel.fromAddress
		newActivity.toAddress = activityModel.toAddress
		newActivity.blockTime = activityModel.blockTime
		newActivity.gasUsed = activityModel.gasUsed
		newActivity.gasPrice = activityModel.gasPrice
		newActivity.accountAddress = accountAddress
		newActivity.status = ActivityStatus.pending.rawValue

		let newActivityDetails = CDUnwrapETHActivityDetails(context: activityDataSource.managedContext)

		newActivityDetails.amount = activityModel.detail.amount

		newActivity.details = newActivityDetails

		activityDataSource.save(newActivity)
		return newActivity
	}

	public func getAllActivities() -> [CDActivityParent] {
		activityDataSource.getAll()
	}

	public func getUserAllActivities(userID: String) -> [CDActivityParent] {
		activityDataSource.getAll().filter { $0.accountAddress == userID }
	}

	public func deleteActivityByID(_ id: String) {
		activityDataSource.deleteByID(id)
	}

	public func deleteAllActivities() {
		activityDataSource.deleteAllActivities()
	}

	public func performSpeedUpChanges(txHash: String, newTxHash: String, newGasPrice: String) {
		activityDataSource.performSpeedUpChanges(txHash: txHash, newTxHash: newTxHash, newGasPrice: newGasPrice)
	}

	public func changePendingActivityToDone(activityModel: ActivityBaseModel) {
		activityDataSource.changePendingActivityToDone(activityBaseModel: activityModel)
	}
}
