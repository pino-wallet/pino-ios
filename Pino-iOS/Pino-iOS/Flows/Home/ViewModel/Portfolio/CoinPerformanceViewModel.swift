//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//
import Charts
import Combine
import Foundation

class CoinPerformanceViewModel {
	// MARK: - Private Properties

	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let selectedAsset: AssetViewModel

	// MARK: - Public Properties

	public let assetName: String
	public let assetImage: URL
	public let netProfitTitle = "Net profit"
	public let allTimeHighTitle = "ATH"
	public let allTimeLowTitle = "ATL"
	@Published
	public var chartVM: AssetChartViewModel?
	@Published
	public var coinInfoVM: CoinPerformanceInfoViewModel?

	// MARK: - Initializers

	init(selectedAsset: AssetViewModel) {
		self.selectedAsset = selectedAsset
		self.assetName = selectedAsset.name
		self.assetImage = selectedAsset.image
		getChartData()
		setupBindings()
	}

	// MARK: - Private Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) {
		accountingAPIClient.coinPerformance(timeFrame: dateFilter.timeFrame, tokenID: selectedAsset.assetVM.id)
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
