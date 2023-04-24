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
	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?
	public var coinInfoVM: CoinPerformanceInfoViewModel!

	// MARK: - Initializers

	init() {
		getChartData()
		getCoinInfo()
	}

	// MARK: - Private Methods

	public func getChartData(dateFilter: ChartDateFilter = .hour) {
		accountingAPIClient.coinPerformance(timeFrame: dateFilter.timeFrame)
			.sink { completed in
				switch completed {
				case .finished:
					print("Portfolio received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0) }
				self.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter)
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
}
