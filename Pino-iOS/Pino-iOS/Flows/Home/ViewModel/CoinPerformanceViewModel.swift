//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Charts
import Combine

class CoinPerformanceViewModel {
	// MARK: - Private Properties

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel!
	public var coinInfoVM: CoinPerformanceInfoViewModel!

	// MARK: - Initializers

	init() {
		getChartData()
		getCoinInfo()
	}

	// MARK: - Private Methods

	private func getChartData() {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("Chart info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModelList in
			self?.chartVM = AssetChartViewModel(chartModel: chartModelList.first!, dateFilter: .hour)
		}.store(in: &cancellables)
	}

	private func getCoinInfo() {
		assetsAPIClient.performanceInfo().sink { completed in
			switch completed {
			case .finished:
				print("Coin info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] coinInfo in
			self?.coinInfoVM = CoinPerformanceInfoViewModel(coinPerformanceInfoModel: coinInfo)
		}.store(in: &cancellables)
	}

	public func updateChartData(by dateFilter: ChartDateFilter) {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("Chart info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModelList in
			var chartModel: AssetChartModel
			switch dateFilter {
			case .hour:
				chartModel = chartModelList[0]
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
			self?.chartVM = AssetChartViewModel(chartModel: chartModel, dateFilter: dateFilter)
		}.store(in: &cancellables)
	}
}
