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
		walletInfo = AccountInfoViewModel(walletAccountInfoModel: selectedWallet)
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
}
