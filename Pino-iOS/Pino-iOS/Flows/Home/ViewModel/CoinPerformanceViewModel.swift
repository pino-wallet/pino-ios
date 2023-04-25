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
	@Published
	public var coinInfoVM: CoinPerformanceInfoViewModel?

	// MARK: - Initializers

	init() {
		getChartData()
//		getCoinInfo()
		setupBindings()
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

	private func setupBindings() {
		$chartVM.sink { chart in
			guard let chart else { return }
			self.updateCoinPerformanceInfo(chart: chart)
		}.store(in: &cancellables)
	}

	private func updateCoinPerformanceInfo(chart: AssetChartViewModel) {
		coinInfoVM = CoinPerformanceInfoViewModel(
			netProfit: "0",
			ATH: allTimeHigh(chart: chart),
			ATL: allTimeLow(chart: chart)
		)
	}

	private func allTimeHigh(chart: AssetChartViewModel) -> String {
		let networthList = chart.chartDataEntry.map { $0.y }
		let maxNetworth = networthList.max()
		return String(maxNetworth!)
	}

	private func allTimeLow(chart: AssetChartViewModel) -> String {
		let networthList = chart.chartDataEntry.map { $0.y }
		let minNetworth = networthList.min()
		return String(minNetworth!)
	}
}
