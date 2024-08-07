//
//  ImportAccountsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Combine
import Foundation
import PromiseKit
import WalletCore
import Web3

class ImportAccountsViewModel {
	// MARK: - Private Properties

	private let pinoWalletManager = PinoHDWallet()
	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let internetConnectivity = InternetConnectivity()
	private var createdWallet: HDWallet?
	private var randAvatarGen = RandGenerator()
	private let accountActivationVM = AccountActivationViewModel()

	// MARK: Public Properties

	public let pageTitle = "Import account"
	public let signDescriptionText =
		"By tapping on Continue, you sign an off-chain message that actives the selected account(s) in Pino."
	public let signDecriptionBoldText = "Continue"
	public let continueButtonText = "Continue"
	public var pageDescription: String {
		if accounts.first(where: { $0.isNewWallet }) != nil {
			return "You have no account with activity. Try to import some new one."
		}
		if accounts.count > 1 {
			return "We have found \(accounts.count) accounts with activity"
		} else {
			return "We have found an account with activity"
		}
	}

	public var walletMnemonics: String
	public var findMoreAccountTitle = "Find more accounts"
	public var noMoreAccountTitle = "No active accounts found"
	public var isMoreAccountExist = true
	public var lastAccountIndex = 0

	@Published
	public var accounts: [ActiveAccountViewModel] = []

	// MARK: - Initializers

	init(walletMnemonics: String) {
		self.walletMnemonics = walletMnemonics
	}

	// MARK: - Private Methods

	private func getWallet() -> Promise<HDWallet> {
		Promise<HDWallet> { seal in
			if let createdWallet {
				seal.fulfill(createdWallet)
			} else {
				createWallet(mnemonics: walletMnemonics).done { wallet in
					seal.fulfill(wallet)
				}.catch { error in
					seal.reject(error)
				}
			}
		}
	}

	private func createWallet(mnemonics: String) -> Promise<HDWallet> {
		Promise<HDWallet> { seal in
			internetConnectivity.$isConnected.tryCompactMap { $0 }.sink { _ in } receiveValue: { [self] isConnected in
				if isConnected {
					pinoWalletManager.createHDWallet(mnemonics: mnemonics).done { hdWallet in
						seal.fulfill(hdWallet)
					}.catch { error in
						seal.reject(error)
					}
				} else {
					seal.reject(APIError.networkConnection)
				}

			}.store(in: &cancellables)
		}
	}

	private func createAccount(wallet: HDWallet, accountIndex: Int) -> Promise<Account> {
		Promise<Account> { seal in
			let derivationPath = "m/44'/60'/0'/0/\(accountIndex)"
			let privateKey = wallet.getKey(coin: .ethereum, derivationPath: derivationPath)
			do {
				let account = try Account(privateKeyData: privateKey.data)
				account.derivationPath = derivationPath
				seal.fulfill(account)
			} catch {
				seal.reject(error)
			}
		}
	}

	private func getActiveAddresses(accountAddresses: [String]) -> Promise<[String]> {
		Promise<[String]> { seal in
			accountingAPIClient.activeAddresses(addresses: accountAddresses)
				.sink { completed in
					switch completed {
					case .finished:
						print("Accounts received successfully")
					case let .failure(error):
						print("Error getting accounts:\(error)")
						seal.reject(error)
					}
				} receiveValue: { accounts in
					print("Active accounts: \(accounts)")
					seal.fulfill(accounts.addresses)
				}.store(in: &cancellables)
		}
	}

	private func getAccountsBalance(of accounts: [Account]) -> Promise<[ActiveAccountViewModel]> {
		Promise<[ActiveAccountViewModel]> { seal in
			let promises = accounts.compactMap { account in
				Web3Core.shared.getETHBalance(of: account.eip55Address).map {
					ActiveAccountViewModel(account: account, balance: $0, avatar: self.randAvatarGen.randAvatar())
				}
			}
			when(fulfilled: promises).done { accountsVM in
				seal.fulfill(accountsVM)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func setupActiveAccounts(_ activeAccounts: [ActiveAccountViewModel]) -> Promise<[ActiveAccountViewModel]> {
		Promise<[ActiveAccountViewModel]> { seal in
			self.accounts = self.accounts + activeAccounts
			guard self.accounts.isEmpty else {
				seal.fulfill(self.accounts)
				return
			}
			activateNewAccount().done { newCreatedAccount in
				self.accounts = [newCreatedAccount]
				seal.fulfill(self.accounts)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func activateNewAccount() -> Promise<ActiveAccountViewModel> {
		Promise<ActiveAccountViewModel> { seal in
			firstly {
				createAccount(wallet: createdWallet!, accountIndex: 0)
			}.then { account in
				self.accountActivationVM.activateNewAccountAddress(account).map { (account, $0) }
			}.done { account, _ in
				let activatedAccount = ActiveAccountViewModel(
					account: account,
					balance: nil,
					isNewWallet: true,
					avatar: self.randAvatarGen.randAvatar()
				)
				seal.fulfill(activatedAccount)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func createAccounts(of wallet: HDWallet, from firstIndex: Int, to lastIndex: Int) -> Promise<[Account]> {
		Promise<[Account]> { seal in
			self.createdWallet = wallet
			var createdAccounts: [Promise<Account>] = []
			for index in firstIndex ... lastIndex {
				self.lastAccountIndex = index
				createdAccounts.append(self.createAccount(wallet: wallet, accountIndex: index))
			}
			when(fulfilled: createdAccounts).done { accounts in
				seal.fulfill(accounts)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func getActiveAccounts(form firstIndex: Int, to lastIndex: Int) -> Promise<[ActiveAccountViewModel]> {
		firstly {
			getWallet()
		}.then { wallet in
			self.createAccounts(of: wallet, from: firstIndex, to: lastIndex)
		}.then { createdAccounts -> Promise<([Account], [String])> in
			let accountAddresses = createdAccounts.map { $0.eip55Address.lowercased() }
			return self.getActiveAddresses(accountAddresses: accountAddresses).map { (createdAccounts, $0) }
		}.then { createdAccounts, activeAddresses -> Promise<[ActiveAccountViewModel]> in
			let activeAccounts = createdAccounts.filter {
				activeAddresses.contains($0.eip55Address.lowercased())
			}
			if !activeAccounts.compactMap({ $0.eip55Address }).contains(createdAccounts.last!.eip55Address) {
				self.isMoreAccountExist = false
			}
			return self.getAccountsBalance(of: activeAccounts)
		}.map { activatedAccounts in
			activatedAccounts.filter { !$0.balance.isZero }
		}.then { activeAccounts -> Promise<[ActiveAccountViewModel]> in
			self.setupActiveAccounts(activeAccounts)
		}
	}

	private func saveSyncFinishTime(accountsResponse: [AccountActivationModel]) {
		accountsResponse.forEach { account in
			SyncWalletViewModel.saveSyncTime(accountInfo: account)
		}
	}

	// MARK: - Public Methods

	public func startSync() -> Promise<Void> {
		Promise<Void> { seal in
			let selectedAccounts = accounts.filter { $0.isSelected }

			let activateAccountsReqs: [Promise<AccountActivationModel>] = selectedAccounts.map { selectedAccount in
				accountActivationVM.activateNewAccountAddress(selectedAccount.account)
			}

			when(fulfilled: activateAccountsReqs).done { [unowned self] activateAccountsResp in
				saveSyncFinishTime(accountsResponse: activateAccountsResp)
				seal.fulfill(())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getFirstAccounts() -> Promise<[ActiveAccountViewModel]> {
		getActiveAccounts(form: 0, to: 9)
	}

	public func findMoreAccounts() -> Promise<[ActiveAccountViewModel]> {
		getActiveAccounts(form: lastAccountIndex + 1, to: lastAccountIndex + 10)
	}
}
