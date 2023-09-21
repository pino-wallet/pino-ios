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

	private func createWallet(mnemonics: String, walletCreated: @escaping (HDWallet?, WalletOperationError?) -> Void) {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.sink { _ in } receiveValue: { [self] isConnected in
			if isConnected {
				let hdWallet = pinoWalletManager.createHDWallet(mnemonics: mnemonics)
				switch hdWallet {
				case let .success(hdWallet):
					walletCreated(hdWallet, nil)
				case let .failure(error):
					walletCreated(nil, error)
				}
			} else {
				walletCreated(nil, .wallet(.netwrokError))
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

	private func getActiveAddresses(accountAddresses: [String], completion: @escaping ([String]) -> Void) {
		accountingAPIClient.activeAddresses(addresses: accountAddresses)
			.sink { completed in
				switch completed {
				case .finished:
					print("Accounts received successfully")
				case let .failure(error):
					print("Error getting accounts:\(error)")
				}
			} receiveValue: { accounts in
				print("Active accounts: \(accounts)")
				completion(accounts.addresses)
			}.store(in: &cancellables)
	}

	private func getAccountsBalance(of accounts: [Account], completion: @escaping ([ActiveAccountViewModel]) -> Void) {
		let promises = accounts.compactMap { account in
			Web3Core.shared.getETHBalance(of: account.eip55Address).map {
				ActiveAccountViewModel(account: account, balance: $0)
			}
		}
		when(fulfilled: promises).done { accountsVM in
			completion(accountsVM)
		}.catch { error in
		}
	}

	private func setupActiveAccounts(createdAccounts: [Account], completion: @escaping () -> Void) {
		let accountAddresses = createdAccounts.map { $0.eip55Address.lowercased() }
		getActiveAddresses(accountAddresses: accountAddresses) { activeAccountAddresses in
			let activeAccounts = createdAccounts.filter {
				activeAccountAddresses.contains($0.eip55Address.lowercased())
			}
			self.getAccountsBalance(of: activeAccounts) { accountsVM in
				self.accounts = self.accounts! + accountsVM
				completion()
			}
			if !activeAccounts.compactMap({ $0.eip55Address }).contains(createdAccounts.last!.eip55Address) {
				self.lastAccountIndex = nil
			}
		}
	}

	// MARK: - Public Methods

	public func getFirstAccounts(completion: @escaping () -> Void) {
		createWallet(mnemonics: walletMnemonics) { wallet, error in
			guard let wallet else { return }
			self.createdWallet = wallet
			var createdAccounts: [Account] = []
			for index in 0 ..< 10 {
				self.lastAccountIndex = index
				do {
					let account = try self.createAccount(wallet: wallet, accountIndex: index)
					createdAccounts.append(account)
				} catch {}
			}
			self.accounts = []
			self.setupActiveAccounts(createdAccounts: createdAccounts) {
				completion()
			}
		}
	}

	public func findMoreAccounts(completion: @escaping () -> Void) {
		guard let lastAccountIndex else { return }
		if let createdWallet {
			var createdAccounts: [Account] = []
			for index in (lastAccountIndex + 1) ... (lastAccountIndex + 10) {
				self.lastAccountIndex = index
				do {
					let account = try createAccount(wallet: createdWallet, accountIndex: index)
					createdAccounts.append(account)
				} catch {}
			}
			setupActiveAccounts(createdAccounts: createdAccounts, completion: completion)
		} else {
			self.lastAccountIndex = 0
			getFirstAccounts(completion: completion)
		}
	}
}
