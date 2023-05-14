//
//  Homepage+Wallet.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/13/23.
//

import Foundation

extension HomepageViewModel {
	// MARK: Internal Methods

	internal func getWalletInfo() {
		// Request to get wallet info
		let coreDataManager = CoreDataManager()
		let selectedWallet = coreDataManager.getAllWalletAccounts().first(where: { $0.isSelected })
		walletInfo = WalletInfoViewModel(walletInfoModel: selectedWallet)
	}

	internal func getWalletBalance() {
		// Request to get balance
		walletAPIClient.walletBalance().sink { completed in
			switch completed {
			case .finished:
				print("Wallet balance received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { walletBalance in
			self.walletBalance = WalletBalanceViewModel(balanceModel: walletBalance)
		}.store(in: &cancellables)
	}

	// MARK: Private Methods

//	private func getWalletInfoFromUserDefaults() -> WalletInfoModel? {
//		guard let encodedWallet = UserDefaults.standard.data(forKey: "wallets") else { return nil }
//		do {
//			let decodedWallets = try JSONDecoder().decode([WalletInfoModel].self, from: encodedWallet)
//			return decodedWallets.first(where: { $0.isSelected })
//		} catch {
//			fatalError(error.localizedDescription)
//		}
//	}

//	private func registerWalletsUserDefaults() {
//		walletAPIClient.walletsList().sink { completed in
//			switch completed {
//			case .finished:
//				print("wallets received successfully")
//			case let .failure(error):
//				print(error)
//			}
//		} receiveValue: { wallets in
//			do {
//				let encodedWallets = try JSONEncoder().encode(wallets.walletsList)
//				UserDefaults.standard.register(defaults: ["wallets": encodedWallets])
//			} catch {
//				fatalError(error.localizedDescription)
//			}
//			guard let firstWallet = wallets.walletsList.first(where: { $0.isSelected }) else {
//				fatalError("No selected wallet found in user defaults")
//			}
//			self.walletInfo = WalletInfoViewModel(walletInfoModel: firstWallet)
//		}.store(in: &cancellables)
//	}
}
