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
		if let walletInfoModel = getWalletInfoFromUserDefaults() {
			walletInfo = WalletInfoViewModel(walletInfoModel: walletInfoModel)
		} else {
			registerWalletsUserDefaults()
		}
	}

	internal func getWalletBalance(assets: [AssetViewModel]) {
		let balance = assets
			.compactMap { $0.holdAmountInDollor }
			.reduce(BigNumber(number: 0, decimal: 0), +)
			.formattedAmountOf(type: .price)
		let volatility = assets
			.compactMap { $0.change24h.bigNumber }
			.reduce(BigNumber(number: 0, decimal: 0), +)
		#warning("volatilityPercentage is static for now and must be changed later")
		let volatilityPercentage = "5.5"
		walletBalance = WalletBalanceViewModel(balanceModel: WalletBalanceModel(
			balance: balance,
			volatilityNumber: volatility.description,
			volatilityPercentage: volatilityPercentage,
			volatilityInDollor: volatility.formattedAmountOf(type: .price)
		))
	}

	// MARK: Private Methods

	private func getWalletInfoFromUserDefaults() -> WalletInfoModel? {
		guard let encodedWallet = UserDefaults.standard.data(forKey: "wallets") else { return nil }
		do {
			let decodedWallets = try JSONDecoder().decode([WalletInfoModel].self, from: encodedWallet)
			return decodedWallets.first(where: { $0.isSelected })
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	private func registerWalletsUserDefaults() {
		walletAPIClient.walletsList().sink { completed in
			switch completed {
			case .finished:
				print("wallets received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { wallets in
			do {
				let encodedWallets = try JSONEncoder().encode(wallets.walletsList)
				UserDefaults.standard.register(defaults: ["wallets": encodedWallets])
			} catch {
				fatalError(error.localizedDescription)
			}
			guard let firstWallet = wallets.walletsList.first(where: { $0.isSelected }) else {
				fatalError("No selected wallet found in user defaults")
			}
			self.walletInfo = WalletInfoViewModel(walletInfoModel: firstWallet)
		}.store(in: &cancellables)
	}
}
