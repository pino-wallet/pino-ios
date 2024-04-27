//
//  CoinPerformanceInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Foundation

class CoinPerformanceInfoViewModel {
	// MARK: - Public Properties

	public let netProfitTitle = "Net profit"
	public let allTimeHighTitle = "ATH"
	public let allTimeLowTitle = "ATL"
	@Published
	public var netProfit: String?
	@Published
	public var allTimeHigh: String?
	@Published
	public var allTimeLow: String?
	public var netProfitBigNum: BigNumber = 0.bigNumber

	public func updateAllTimeHigh(_ chartData: [AssetChartDataViewModel]) {
		let networthList = chartData.map { $0.networth.doubleValue }
		let maxNetworth = networthList.max()
		if let maxNetworth, maxNetworth != 0 {
			allTimeHigh = String(maxNetworth).currencyFormatting
		} else {
			allTimeHigh = GlobalZeroAmounts.dollars.zeroAmount
		}
	}

	public func updateAllTimelow(_ chartData: [AssetChartDataViewModel]) {
		let networthList = chartData.map { $0.networth.doubleValue }
		let minNetworth = networthList.min()
		if let minNetworth, minNetworth != 0 {
			allTimeLow = String(minNetworth).currencyFormatting
		} else {
			allTimeLow = GlobalZeroAmounts.dollars.zeroAmount
		}
	}

	public func updateTokenAllTime(_ tokenAllTime: TokenAllTimePerformance, selectedAsset: AssetViewModel) {
		updateAllTimeHigh(tokenAllTime.ath, selectedAsset: selectedAsset)
		updateAllTimelow(tokenAllTime.atl, selectedAsset: selectedAsset)
	}

	public func updateNetProfit(_ chartData: [AssetChartDataViewModel], selectedAsset: AssetViewModel) {
		updateNetProfit(chartData, assetType: selectedAsset.assetType, capital: selectedAsset.assetCapital)
	}

	public func updateNetProfit(_ chartData: [AssetChartDataViewModel], investment: InvestAssetViewModel) {
		updateNetProfit(chartData, assetType: investment.investToken.assetType, capital: investment.investmentCapital)
	}

	// MARK: - Private Methods

	private func updateAllTimeHigh(_ ath: String, selectedAsset: AssetViewModel) {
		let allTimeHighBigNumber = BigNumber(number: ath, decimal: 2)
		if allTimeHighBigNumber.isZero {
			allTimeHigh = GlobalZeroAmounts.dollars.zeroAmount
		} else {
			allTimeHigh = allTimeHighBigNumber.priceFormat(of: selectedAsset.assetType, withRule: .standard)
		}
	}

	private func updateAllTimelow(_ atl: String, selectedAsset: AssetViewModel) {
		let allTimeLowBigNumber = BigNumber(number: atl, decimal: 2)
		if allTimeLowBigNumber.isZero {
			allTimeLow = GlobalZeroAmounts.dollars.zeroAmount
		} else {
			allTimeLow = allTimeLowBigNumber.priceFormat(of: selectedAsset.assetType, withRule: .standard)
		}
	}

	private func updateNetProfit(_ chartData: [AssetChartDataViewModel], assetType: AssetType, capital: BigNumber) {
		guard let currentWorth = chartData.last?.networth else {
			netProfit = GlobalZeroAmounts.dollars.zeroAmount
			return
		}
		netProfitBigNum = currentWorth - capital
		if netProfitBigNum.isZero {
			netProfit = GlobalZeroAmounts.dollars.zeroAmount
			return
		}
		if netProfitBigNum < 0.bigNumber {
			netProfit = "-\(netProfitBigNum.priceFormat(of: assetType, withRule: .standard))"
		} else {
			netProfit = netProfitBigNum.priceFormat(of: assetType, withRule: .standard)
		}
	}
}
