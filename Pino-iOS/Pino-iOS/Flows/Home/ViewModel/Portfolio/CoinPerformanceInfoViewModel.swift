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

	public func updateNetProfit(_ chartData: [AssetChartDataViewModel], selectedAsset: AssetViewModel) {
		guard let currentWorth = chartData.last?.networth else {
			netProfit = GlobalZeroAmounts.dollars.zeroAmount
			return
		}
		let userNetProfit = currentWorth - selectedAsset.assetCapital
		if userNetProfit.isZero {
			netProfit = GlobalZeroAmounts.dollars.zeroAmount
			return
		}
		if userNetProfit < 0.bigNumber {
			netProfit = "-\(userNetProfit.priceFormat(of: selectedAsset.assetType, withRule: .standard))"
		} else {
			netProfit = userNetProfit.priceFormat(of: selectedAsset.assetType, withRule: .standard)
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

	public func updateTokenAllTime(_ tokenAllTime: TokenAllTimePerformance, selectedAsset: AssetViewModel) {
		updateAllTimeHigh(tokenAllTime.ath, selectedAsset: selectedAsset)
		updateAllTimelow(tokenAllTime.atl, selectedAsset: selectedAsset)
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
}
