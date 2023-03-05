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

	public var netProfit: (key: String, value: String) {
		(key: "Net profit", value: "$\(coinPerformanceInfoModel.netProfit)")
	}

	public var allTimeHigh: (key: String, value: String) {
		(key: "All time high", value: "$\(coinPerformanceInfoModel.allTimeHigh)")
	}

	public var allTimeLow: (key: String, value: String) {
		(key: "All time low", value: "$\(coinPerformanceInfoModel.allTimeLow)")
	}
}
