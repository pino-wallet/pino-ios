//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//
import Combine
import DGCharts
import Foundation

class CoinPerformanceViewModel {
	// MARK: - Private Properties

	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let selectedAsset: AssetViewModel

	// MARK: - Public Properties

	public let assetName: String
	public let assetImage: URL
	@Published
	public var chartVM: AssetChartViewModel?
	public var coinInfoVM = CoinPerformanceInfoViewModel()

	// MARK: - Initializers

	init(selectedAsset: AssetViewModel) {
		self.selectedAsset = selectedAsset
		self.assetName = selectedAsset.symbol
		self.assetImage = selectedAsset.image
		getChartData()
		getCoinPerformanceInfo()
	}

	// MARK: - Private Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) {
		accountingAPIClient.coinPerformance(timeFrame: dateFilter.timeFrame, tokenID: selectedAsset.id)
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

	private func getCoinPerformanceInfo() {
		let allTimeFrame = ChartDateFilter.all.timeFrame
		accountingAPIClient.coinPerformance(timeFrame: allTimeFrame, tokenID: selectedAsset.id)
			.sink { completed in
				switch completed {
				case .finished:
					print("Portfolio received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0) }
				self.coinInfoVM.coinPerformanceInfo = CoinPerformanceInfoValues(
					netProfit: self.userNetProfit(chart: chartDataVM),
					ATH: self.allTimeHigh(chart: chartDataVM),
					ATL: self.allTimeLow(chart: chartDataVM)
				)
			}.store(in: &cancellables)
	}

	private func allTimeHigh(chart: [AssetChartDataViewModel]) -> String {
		let networthList = chart.map { $0.networth.doubleValue }
		let maxNetworth = networthList.max()
		guard let maxNetworth, maxNetworth != 0 else { return GlobalZeroAmounts.plain.zeroAmount }
		return String(maxNetworth)
	}

	private func allTimeLow(chart: [AssetChartDataViewModel]) -> String {
		let networthList = chart.map { $0.networth.doubleValue }
		let minNetworth = networthList.min()
		guard let minNetworth, minNetworth != 0 else { return GlobalZeroAmounts.plain.zeroAmount }
		return String(minNetworth)
	}

	private func userNetProfit(chart: [AssetChartDataViewModel]) -> String {
		guard let currentWorth = chart.last?.networth else { return GlobalZeroAmounts.plain.zeroAmount }
		let selectedAssetCapital = BigNumber(number: selectedAsset.assetModel.capital, decimal: 2)
		let userNetProfit = currentWorth - selectedAssetCapital
		return userNetProfit.decimalString
	}
}
