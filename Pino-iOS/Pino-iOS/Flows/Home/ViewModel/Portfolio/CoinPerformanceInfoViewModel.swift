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

	public func updateNetProfit(_ chartData: [AssetChartDataViewModel], selectedAssetCapital: BigNumber) {
		guard let currentWorth = chartData.last?.networth else {
			netProfit = GlobalZeroAmounts.dollars.zeroAmount
			return
		}
		let userNetProfit = currentWorth - selectedAssetCapital
		if userNetProfit.isZero {
			netProfit = GlobalZeroAmounts.dollars.zeroAmount
			return
		}
		if userNetProfit < 0.bigNumber {
			netProfit = "-\(userNetProfit.priceFormat)"
		} else {
			netProfit = userNetProfit.priceFormat
		}
	}

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

	public func updateTokenAllTime(_ tokenAllTime: TokenAllTimePerformance) {
		updateAllTimeHigh(tokenAllTime.ath)
		updateAllTimelow(tokenAllTime.atl)
	}

	// MARK: - Private Methods

	private func updateAllTimeHigh(_ ath: String) {
		let allTimeHighBigNumber = BigNumber(number: ath, decimal: 2)
		if allTimeHighBigNumber.isZero {
			allTimeHigh = GlobalZeroAmounts.dollars.zeroAmount
		} else {
			allTimeHigh = allTimeHighBigNumber.priceFormat
		}
	}

	private func updateAllTimelow(_ atl: String) {
		let allTimeLowBigNumber = BigNumber(number: atl, decimal: 2)
		if allTimeLowBigNumber.isZero {
			allTimeLow = GlobalZeroAmounts.dollars.zeroAmount
		} else {
			allTimeLow = allTimeLowBigNumber.priceFormat
		}
	}
}
