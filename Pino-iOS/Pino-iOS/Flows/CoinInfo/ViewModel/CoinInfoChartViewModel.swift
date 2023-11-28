//
//  CoinInfoChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import Combine
import DGCharts

class CoinInfoChartViewModel {
	// MARK: - Private Properties

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel!
	public var aboutCoinVM: AboutCoinViewModel!

	// MARK: - Initializers

	init() {
		getChartData()
		getAboutCoin()
	}

	// MARK: - Private Methods

	private func getChartData() {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModelList in
			let chartDataVM = chartModelList.first!.chartData.compactMap { AssetChartDataViewModel(chartModel: $0) }
			self?.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: .day)
		}.store(in: &cancellables)
	}

	private func getAboutCoin() {
		assetsAPIClient.aboutCoin().sink { completed in
			switch completed {
			case .finished:
				print("")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] aboutCoin in
			self?.aboutCoinVM = AboutCoinViewModel(aboutCoin: aboutCoin)
		}.store(in: &cancellables)
	}

	// MARK: - Public Methods

	public func updateChartData(by dateFilter: ChartDateFilter) {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModelList in
			var chartModel: AssetChartModel
			#warning("It is temporary and must be replaced by API data")
			switch dateFilter {
			case .day:
				chartModel = chartModelList[1]
			case .week:
				chartModel = chartModelList[2]
			case .month:
				chartModel = chartModelList[3]
			case .year:
				chartModel = chartModelList[4]
			case .all:
				chartModel = chartModelList[5]
			}
			let chartDataVM = chartModel.chartData.compactMap { AssetChartDataViewModel(chartModel: $0) }
			self?.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter)
		}.store(in: &cancellables)
	}
}
