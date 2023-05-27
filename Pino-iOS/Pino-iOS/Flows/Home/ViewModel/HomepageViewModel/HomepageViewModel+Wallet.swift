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
		let balance = getAssetsHoldAmount(assets)
		let previousBalance = getAssetsPreviousHoldAmount(assets)
		let volatility = balance - previousBalance
		let volatilityPercentage = getVolatilityPercentage(balance: balance, previousBalance: previousBalance)

		walletBalance = WalletBalanceViewModel(balanceModel: WalletBalanceModel(
			balance: balance.formattedAmountOf(type: .price),
			volatilityNumber: volatility.description,
			volatilityPercentage: volatilityPercentage,
			volatilityInDollor: volatility.formattedAmountOf(type: .price)
		))
	}

	// MARK: Private Methods

	private func getAssetsHoldAmount(_ assets: [AssetViewModel]) -> BigNumber {
		assets
			.compactMap { $0.holdAmountInDollor }
			.reduce(BigNumber(number: 0, decimal: 0), +)
	}

	private func getAssetsPreviousHoldAmount(_ assets: [AssetViewModel]) -> BigNumber {
		assets
			.compactMap { $0.previousDayNetworth }
			.reduce(BigNumber(number: 0, decimal: 0), +)
	}

	private func getVolatilityPercentage(balance: BigNumber, previousBalance: BigNumber) -> String {
		let volatility = balance.doubleValue - previousBalance.doubleValue
		let volatilityPercentage = (volatility / previousBalance.doubleValue) * 100
		return "\(abs(volatilityPercentage.roundToPlaces(2)))"
	}
}
