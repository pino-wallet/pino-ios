//
//  CoinInfoChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

struct CoinInfoChartViewModel {
	// MARK: - Private Properties

	private var coinInfoChartModel: CoinInfoChartModel!

	// MARK: - Public Properties

	public var website: (key: String, value: String) {
		(key: "Website", value: coinInfoChartModel.website)
	}

	public var marketCap: (key: String, value: String) {
		(key: "Market Cap", value: "$\(coinInfoChartModel.marketCap)")
	}

	public var Valume: (key: String, value: String) {
		(key: "Valume (24h)", value: coinInfoChartModel.Valume)
	}

	public var circulatingSupply: (key: String, value: String) {
		(key: "Circulating supply", value: coinInfoChartModel.circulatingSupply)
	}

	public var totalSuply: (key: String, value: String) {
		(key: "Total supply", value: coinInfoChartModel.totalSuply)
	}

	// MARK: - Initializers

	init() {
		getChartInfo()
	}

	// MARK: - Private Methods

	private mutating func getChartInfo() {
		let chartModel = CoinInfoChartModel(
			website: "Something.com",
			marketCap: "465,836,000",
			Valume: "19,476,500",
			circulatingSupply: "4,933,588",
			totalSuply: "4,933,588"
		)
		coinInfoChartModel = chartModel
	}
}
