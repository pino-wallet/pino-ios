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

	// MARK: Public Properties

	public let pageTitle = "Import account"
	public var pageDescription: String {
		guard let accounts else { return .emptyString }
		if accounts.count > 1 {
			return "We found \(accounts.count) accounts with activity"
		} else {
			return "We found an account with activity"
		}
	}

	public var footerTitle = "Find more accounts"
	public var walletMnemonics: String
	public var lastAccountIndex: Int?

	@Published
	public var accounts: [ActiveAccountViewModel]?

	// MARK: - Initializers

	init(walletMnemonics: String) {
		self.walletMnemonics = walletMnemonics
	}

	// MARK: Private Methods

	private func createWallet(mnemonics: String, completion: @escaping (Result<HDWallet>) -> Void) {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.sink { _ in } receiveValue: { [self] isConnected in
			if isConnected {
				let hdWallet = pinoWalletManager.createHDWallet(mnemonics: mnemonics)
				switch hdWallet {
				case let .success(hdWallet):
					completion(.fulfilled(hdWallet))
				case let .failure(error):
					completion(.rejected(error))
				}
			} else {
				completion(.rejected(WalletOperationError.wallet(.netwrokError)))
			}
		}.store(in: &cancellables)
	}

	private func createAccount(wallet: HDWallet, accountIndex: Int) throws -> Account {
		let derivationPath = "m/44'/60'/0'/0/\(accountIndex)"
		let privateKey = wallet.getKey(coin: .ethereum, derivationPath: derivationPath)
		let account = try Account(privateKeyData: privateKey.data)
		account.derivationPath = derivationPath
		return account
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
					ActiveAccountViewModel(account: account, balance: $0)
				}
			}
			when(fulfilled: promises).done { accountsVM in
				seal.fulfill(accountsVM)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

//	private func setupActiveAccounts(createdAccounts: [Account], completion: @escaping (Error?) -> Void) {
//		let accountAddresses = createdAccounts.map { $0.eip55Address.lowercased() }
//		getActiveAddresses(accountAddresses: accountAddresses) { result in
//			switch result {
//			case let .fulfilled(activeAccountAddresses):
//				let activeAccounts = createdAccounts.filter {
//					activeAccountAddresses.contains($0.eip55Address.lowercased())
//				}
//				self.getAccountsBalance(of: activeAccounts) { accountsVM in
	//                    self.updateAccountsList(accountsVM) { error in
	//                        completion(error)
	//                    }
//				}
//				if !activeAccounts.compactMap({ $0.eip55Address }).contains(createdAccounts.last!.eip55Address) {
//					self.lastAccountIndex = nil
//				}
//			case let .rejected(error):
//				completion(error)
//			}
//		}
//	}

	private func setupActiveAccounts(createdAccounts: [Account]) -> Promise<[ActiveAccountViewModel]> {
		firstly {
			let accountAddresses = createdAccounts.map { $0.eip55Address.lowercased() }
			return getActiveAddresses(accountAddresses: accountAddresses)
		}.then { activeAddressses in
			let activeAccounts = createdAccounts.filter {
				activeAddressses.contains($0.eip55Address.lowercased())
			}
			if !activeAccounts.compactMap({ $0.eip55Address }).contains(createdAccounts.last!.eip55Address) {
				self.lastAccountIndex = nil
			}
			return self.getAccountsBalance(of: activeAccounts)
		}.then { activeAccounts in
			self.updateAccountsList(activeAccounts)
		}
	}

	private func updateAccountsList(_ activeAccounts: [ActiveAccountViewModel]) -> Promise<[ActiveAccountViewModel]> {
		Promise<[ActiveAccountViewModel]> { seal in
			self.accounts = self.accounts! + activeAccounts
			if self.accounts!.isEmpty {
				createNewAccount().done { newCreatedAccount in
					self.accounts = [newCreatedAccount]
					seal.fulfill(self.accounts!)
				}.catch { error in
					seal.reject(error)
				}
			} else {
				seal.fulfill(self.accounts!)
			}
		}
	}

	private func createNewAccount() -> Promise<ActiveAccountViewModel> {
		Promise<ActiveAccountViewModel> { seal in
		}
	}

	// MARK: - Public Methods

	public func getFirstAccounts(completion: @escaping (Error?) -> Void) {
		createWallet(mnemonics: walletMnemonics) { result in
			switch result {
			case let .fulfilled(wallet):
				self.createdWallet = wallet
				var createdAccounts: [Account] = []
				for index in 0 ..< 10 {
					self.lastAccountIndex = index
					do {
						let account = try self.createAccount(wallet: wallet, accountIndex: index)
						createdAccounts.append(account)
					} catch {
						completion(error)
					}
				}
				self.accounts = []
				self.setupActiveAccounts(createdAccounts: createdAccounts, completion: completion)
			case let .rejected(error):
				completion(error)
			}
		}
	}

	public func findMoreAccounts(completion: @escaping (Error?) -> Void) {
		guard let lastAccountIndex else { return }
		if let createdWallet {
			var createdAccounts: [Account] = []
			for index in (lastAccountIndex + 1) ... (lastAccountIndex + 10) {
				self.lastAccountIndex = index
				do {
					let account = try createAccount(wallet: createdWallet, accountIndex: index)
					createdAccounts.append(account)
				} catch {
					completion(error)
				}
			}
			setupActiveAccounts(createdAccounts: createdAccounts, completion: completion)
		} else {
			getFirstAccounts(completion: completion)
		}
	}
}
