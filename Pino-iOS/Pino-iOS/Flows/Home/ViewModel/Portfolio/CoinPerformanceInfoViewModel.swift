//
//  CoinPerformanceInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//
struct CoinPerformanceInfoViewModel {
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
