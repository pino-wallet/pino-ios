//
//  CoinInfoChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import Combine

class CoinInfoChartViewModel {
	// MARK: - Private Properties

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	private var coinInfoChartModel: CoinInfoChartModel!

	// MARK: - Public Properties

	public var website: (key: String, value: String) {
		(key: "Website", value: coinInfoChartModel.website)
	}

	public var marketCap: (key: String, value: String) {
		(key: "Market Cap", value: "$\(coinInfoChartModel.marketCap)")
	}

	public var Valume: (key: String, value: String) {
		(key: "Valume (24h)", value: coinInfoChartModel.valume)
	}

	public var circulatingSupply: (key: String, value: String) {
		(key: "Circulating supply", value: coinInfoChartModel.circulatingSupply)
	}

	public var totalSuply: (key: String, value: String) {
		(key: "Total supply", value: coinInfoChartModel.totalSuply)
	}

	public var explorerURL: String {
		coinInfoChartModel.explorerURL
	}

	// MARK: - Initializers

	init() {
		getChartInfo()
	}

	// MARK: - Private Methods

	private func getChartInfo() {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("Chart info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModel in
			self?.coinInfoChartModel = chartModel
		}.store(in: &cancellables)
	}
}
