//
//  CoinPerformanceInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Foundation

class CoinPerformanceInfoViewModel {
	// MARK: - Public Properties

	@Published
	public var coinPerformanceInfo: CoinPerformanceInfoValues?
	public let netProfitTitle = "Net profit"
	public let allTimeHighTitle = "ATH"
	public let allTimeLowTitle = "ATL"
}

struct CoinPerformanceInfoValues {
	// MARK: - Public Properties

	public var coinPerformanceInfoModel: CoinPerformanceInfoModel

	public var netProfit: String {
		coinPerformanceInfoModel.netProfit.currencyFormatting
	}

	public var allTimeHigh: String {
		coinPerformanceInfoModel.allTimeHigh.currencyFormatting
	}

	public var allTimeLow: String {
		coinPerformanceInfoModel.allTimeLow.currencyFormatting
	}

	// MARK: - Initializers

	init(netProfit: String, ATH: String, ATL: String) {
		self.coinPerformanceInfoModel = CoinPerformanceInfoModel(
			netProfit: netProfit,
			allTimeHigh: ATH,
			allTimeLow: ATL
		)
	}
}
