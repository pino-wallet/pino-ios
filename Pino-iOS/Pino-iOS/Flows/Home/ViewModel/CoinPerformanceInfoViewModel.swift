//
//  CoinPerformanceInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//
struct CoinPerformanceInfoViewModel {
	// MARK: - Public Properties

	public var coinPerformanceInfoModel: CoinPerformanceInfoModel

	public var image: String {
		coinPerformanceInfoModel.image
	}

	public var name: String {
		coinPerformanceInfoModel.name
	}

	public var netProfit: String {
		"$\(coinPerformanceInfoModel.netProfit)"
	}

	public var allTimeHigh: String {
		"$\(coinPerformanceInfoModel.allTimeHigh)"
	}

	public var allTimeLow: String {
		"$\(coinPerformanceInfoModel.allTimeLow)"
	}

	init(netProfit: String, ATH: String, ATL: String) {
		self.coinPerformanceInfoModel = CoinPerformanceInfoModel(
			image: "",
			name: "",
			netProfit: netProfit,
			allTimeHigh: ATH,
			allTimeLow: ATL
		)
	}
}
