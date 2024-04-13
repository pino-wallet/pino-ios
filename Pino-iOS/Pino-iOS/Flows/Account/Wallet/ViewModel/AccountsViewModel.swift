//
//  WalletViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine
import Foundation
import PromiseKit
import Web3

class AccountsViewModel {
	// MARK: - Public Properties

	@Published
	public var accountsList: [AccountInfoViewModel]!
	public var currentAccount: AccountInfoViewModel {
		accountsList.first(where: { $0.isSelected })!
	}

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()
	private let coreDataManager = CoreDataManager()
	private let pinoWalletManager = PinoWalletManager()
	private let accountActivationVM = AccountActivationViewModel()

	// MARK: - Initializers

	init(currentWalletBalance: String?) {
		getAccounts()
		if let currentWalletBalance {
			setAccountLastBalance(account: currentAccount, balance: currentWalletBalance)
		}
		if let ethToken = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth }) {
			let userETHBalance = ethToken.holdAmount
			var userETHFormattedPrice: String
			if userETHBalance.isZero {
				userETHFormattedPrice = GlobalZeroAmounts.tokenAmount.zeroAmount.ethFormatting
			} else {
				userETHFormattedPrice = userETHBalance.sevenDigitFormat.ethFormatting
			}
			setAccountLastETHBalance(account: currentAccount, ethBalance: userETHFormattedPrice)
		}
	}

	// MARK: - Private Methods

	private func resetPendingActivities() {
		if !coreDataManager.getAllActivities().isEmpty {
			PendingActivitiesManager.shared.startActivityPendingRequests()
		}
	}

	private func addNewWalletAccountWithAddress(
		_ address: String,
		derivationPath: String?,
		publicKey: EthereumPublicKey,
		accountName: String?,
		accountAvatar: Avatar?
	) {
		var walletType: Wallet.WalletType = .nonHDWallet
		if derivationPath != nil {
			walletType = .hdWallet
		}
		let wallet = coreDataManager.getAllWallets().first(where: { $0.walletType == walletType })
		var newAccountName: String
		var newAvatar: Avatar
		if let accountAvatar {
			newAvatar = accountAvatar
			newAccountName = accountName ?? accountAvatar.name
		} else {
			newAvatar = generateRandomAvatar()
			newAccountName = newAvatar.name
		}

		guard let newAccount = coreDataManager.createWalletAccount(
			address: address,
			derivationPath: derivationPath,
			publicKey: publicKey.hex(),
			name: newAccountName,
			avatarIcon: newAvatar.rawValue,
			avatarColor: newAvatar.rawValue,
			wallet: wallet!
		) else { return }
		getAccounts()
		GlobalVariables.shared.updateCurrentAccount(newAccount)
	}

	private func generateRandomAvatar() -> Avatar {
		let walletsAvatar = accountsList.map { $0.profileImage }
		let walletsName = accountsList.map { $0.name }
		return Avatar
			.allCases
			.filter { !walletsAvatar.contains($0.rawValue) && !walletsName.contains($0.name) }
			.randomElement()
			?? .green_apple
	}

	private func registerUserFCMToken(userAdd: String) {
		if let fcmToken = FCMTokenManager.shared.currentToken {
			PushNotificationManager.shared.registerUserFCMToken(token: fcmToken, userAddress: userAdd)
		}
	}

	private func accountExistsInCoreData(account: Account) -> Bool {
		if coreDataManager.getAllWalletAccounts()
			.contains(where: { $0.eip55Address == account.eip55Address }) {
			return true
		} else {
			return false
		}
	}

	// MARK: - Public Methods

	public func getAccounts() {
		// Request to get accounts
		let accounts = coreDataManager.getAllWalletAccounts()
		accountsList = accounts.compactMap { AccountInfoViewModel(walletAccountInfoModel: $0) }
	}

	public func createNewAccount() -> Promise<Void> {
		Promise<Void> { seal in
			let currentWallet = coreDataManager.getSelectedWalletOf(type: .hdWallet)!
			let createdAccount = try pinoWalletManager
				.createAccount(lastAccountIndex: Int(currentWallet.lastDrivedIndex))
			activateNewAccountAddress(
				createdAccount,
				publicKey: createdAccount.publicKey,
				derivationPath: createdAccount.derivationPath
			).done {
				seal.fulfill(())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func importAccount(
		privateKey: String,
		accountName: String,
		accountAvatar: Avatar
	) -> Promise<Void> {
		Promise<Void> { seal in
			firstly {
				pinoWalletManager.importAccount(privateKey: privateKey)
			}.get { importedAccount in
				if self.accountExistsInCoreData(account: importedAccount) {
					seal.reject(WalletOperationError.wallet(.accountAlreadyExists))
				}
			}.then { importedAccount in
				self.activateNewAccountAddress(
					importedAccount,
					publicKey: importedAccount.publicKey,
					accountName: accountName,
					accountAvatar: accountAvatar
				)
			}.done {
				seal.fulfill(())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func activateNewAccountAddress(
		_ account: Account,
		publicKey: EthereumPublicKey,
		derivationPath: String? = nil,
		accountName: String? = nil,
		accountAvatar: Avatar? = nil
	) -> Promise<Void> {
		Promise<Void> { seal in
			accountActivationVM.activateNewAccountAddress(account).done { [self] accountInfo in
				addNewWalletAccountWithAddress(
					account.eip55Address,
					derivationPath: derivationPath,
					publicKey: publicKey,
					accountName: accountName,
					accountAvatar: accountAvatar
				)
				SyncWalletViewModel.saveSyncTime(accountInfo: accountInfo)
				resetPendingActivities()
				registerUserFCMToken(userAdd: account.eip55Address)
				seal.fulfill(())
			}.catch { error in
				seal.reject(WalletOperationError.wallet(.accountActivationFailed(error)))
			}
		}
	}

	public func editAccount(account: AccountInfoViewModel, newName: String) -> AccountInfoViewModel {
		let edittedAccount = coreDataManager.editWalletAccount(account.walletAccountInfoModel, newName: newName)
		getAccounts()
		return AccountInfoViewModel(walletAccountInfoModel: edittedAccount)
	}

	public func editAccount(account: AccountInfoViewModel, newAvatar: String) -> AccountInfoViewModel {
		let edittedAccount = coreDataManager.editWalletAccount(account.walletAccountInfoModel, newAvatar: newAvatar)
		getAccounts()
		return AccountInfoViewModel(walletAccountInfoModel: edittedAccount)
	}

	public func removeAccount(_ walletVM: AccountInfoViewModel) -> Promise<Void> {
		Promise<Void> { seal in
			firstly {
				pinoWalletManager.deleteAccount(account: walletVM.walletAccountInfoModel)
			}.done { [unowned self] removedAccount in
				coreDataManager.deleteWalletAccount(walletVM.walletAccountInfoModel)
				getAccounts()
				GlobalVariables.shared.updateCurrentAccount(currentAccount.walletAccountInfoModel)
				resetPendingActivities()
				seal.fulfill(())
			}.catch { error in
				print("Error: failed to remove account: \(error)")
				seal.reject(error)
			}
		}
	}

	public func setAccountLastBalance(account: AccountInfoViewModel, balance: String) {
		coreDataManager.editWalletAccount(account.walletAccountInfoModel, lastBalance: balance)
	}

	public func setAccountLastETHBalance(account: AccountInfoViewModel, ethBalance: String) {
		coreDataManager.editWalletAccount(account.walletAccountInfoModel, lastETHBalance: ethBalance)
	}

	public func updateSelectedAccount(with selectedAccount: AccountInfoViewModel) {
		coreDataManager.updateSelectedWalletAccount(selectedAccount.walletAccountInfoModel)
		getAccounts()
		GlobalVariables.shared.updateCurrentAccount(selectedAccount.walletAccountInfoModel)
		resetPendingActivities()
	}
}
