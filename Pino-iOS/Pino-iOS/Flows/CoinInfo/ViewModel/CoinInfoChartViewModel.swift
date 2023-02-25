//
//  CoinInfoChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import Charts
import Combine

class CoinInfoChartViewModel {
	// MARK: - Private Properties

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	private var coinInfoChartModel: CoinInfoChartModel!

	// MARK: - Public Properties

	public var chartDataEntry: [ChartDataEntry]!
	public var dateFilters: [ChartDateFilter]!

	public var balance: String {
		"$\(coinInfoChartModel.balance)"
	}

	public var volatilityInDollor: String {
		switch volatilityType {
		case .profit:
			return "+$\(coinInfoChartModel.volatilityInDollor)"
		case .loss:
			return "-$\(coinInfoChartModel.volatilityInDollor)"
		case .none:
			return "$\(coinInfoChartModel.volatilityInDollor)"
		}
	}

	public var volatilityPercentage: String {
		switch volatilityType {
		case .profit:
			return "+\(coinInfoChartModel.volatilityPercentage)%"
		case .loss:
			return "-\(coinInfoChartModel.volatilityPercentage)%"
		case .none:
			return "\(coinInfoChartModel.volatilityPercentage)%"
		}
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(rawValue: coinInfoChartModel.volatilityType) ?? .none
	}

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
		setDateFilters()
	}

	// MARK: - Public Methods

	public func updateChartData(by dateFilter: ChartDateFilter) {}

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

		chartDataEntry = [
			ChartDataEntry(x: 0, y: 0),
			ChartDataEntry(x: 1, y: 1),
			ChartDataEntry(x: 2, y: 0.5),
			ChartDataEntry(x: 3, y: 1.5),
			ChartDataEntry(x: 4, y: 1),
			ChartDataEntry(x: 5, y: 2),
			ChartDataEntry(x: 6, y: 0.5),
			ChartDataEntry(x: 7, y: 1),
			ChartDataEntry(x: 8, y: 0),
			ChartDataEntry(x: 9, y: 2),
		]
	}

	private func setDateFilters() {
		dateFilters = [
			.hour,
			.day,
			.week,
			.month,
			.year,
			.all,
		]
	}
}
