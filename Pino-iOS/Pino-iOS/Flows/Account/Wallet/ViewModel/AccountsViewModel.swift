//
//  WalletViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine
import Foundation
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
		derivationPath: String? = nil,
		publicKey: EthereumPublicKey
	) {
		var walletType: Wallet.WalletType = .nonHDWallet
		if derivationPath != nil {
			walletType = .hdWallet
		}
		let wallet = coreDataManager.getAllWallets().first(where: { $0.walletType == walletType })
		let walletsAvatar = accountsList.map { $0.profileImage }
		let walletsName = accountsList.map { $0.name }
		let newAvatar = Avatar
			.allCases
			.filter { !walletsAvatar.contains($0.rawValue) && !walletsName.contains($0.name) }
			.randomElement()
			?? .green_apple

		guard let newAccount = coreDataManager.createWalletAccount(
			address: address,
			derivationPath: derivationPath,
			publicKey: publicKey.hex(),
			name: newAvatar.name,
			avatarIcon: newAvatar.rawValue,
			avatarColor: newAvatar.rawValue,
			wallet: wallet!
		) else { return }
		getAccounts()
		GlobalVariables.shared.updateCurrentAccount(newAccount)
	}

	// MARK: - Public Methods

	public func getAccounts() {
		// Request to get accounts
		let accounts = coreDataManager.getAllWalletAccounts()
		accountsList = accounts.compactMap { AccountInfoViewModel(walletAccountInfoModel: $0) }
	}

	public func createNewAccount(completion: @escaping (WalletOperationError?) -> Void) {
		let coreDataManager = CoreDataManager()
		let currentWallet = coreDataManager.getSelectedWalletOf(type: .hdWallet)!
		do {
			let createdAccount = try pinoWalletManager
				.createAccount(lastAccountIndex: Int(currentWallet.lastDrivedIndex))
			activateNewAccountAddress(
				createdAccount.eip55Address,
				publicKey: createdAccount.publicKey,
				derivationPath: createdAccount.derivationPath
			) { error in
				completion(error)
			}
		} catch {
			completion(WalletOperationError.unknow(error))
		}
	}

	public func importAccountWith(privateKey: String, completion: @escaping (WalletOperationError?) -> Void) {
		let importedAccount = pinoWalletManager.importAccount(privateKey: privateKey)
		switch importedAccount {
		case let .success(account):
			if coreDataManager.getAllWalletAccounts().contains(where: { $0.eip55Address == account.eip55Address }) {
				completion(WalletOperationError.wallet(.accountAlreadyExists))
			} else {
				activateNewAccountAddress(account.eip55Address, publicKey: account.publicKey) { error in
					completion(error)
				}
			}
		case let .failure(error):
			completion(error)
		}
	}

	public func activateNewAccountAddress(
		_ address: String,
		publicKey: EthereumPublicKey,
		derivationPath: String? = nil,
		completion: @escaping (WalletOperationError?) -> Void
	) {
		let accountActivationVM = AccountActivationViewModel()
		accountActivationVM.activateNewAccountAddress(address).done { accountId in
			self.addNewWalletAccountWithAddress(address, derivationPath: derivationPath, publicKey: publicKey)
			self.resetPendingActivities()
			completion(nil)
		}.catch { error in
			completion(WalletOperationError.wallet(.accountActivationFailed(error)))
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

	public func removeAccount(_ walletVM: AccountInfoViewModel) {
		coreDataManager.deleteWalletAccount(walletVM.walletAccountInfoModel)
		getAccounts()
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
