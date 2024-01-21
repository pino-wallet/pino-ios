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
		self.assetName = selectedAsset.name
		self.assetImage = selectedAsset.image
		getChartData()
		setupBindings()
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

	private func setupBindings() {
		$chartVM.sink { chart in
			guard let chart else { return }
			self.updateCoinPerformanceInfo(chart: chart)
		}.store(in: &cancellables)
	}

	private func updateCoinPerformanceInfo(chart: AssetChartViewModel) {
		let capitalDecimal = 2
		let selectedAssetCapitalBigNumber = BigNumber(number: selectedAsset.assetModel.capital, decimal: capitalDecimal)
		let userNetProfit = (chart.chartDataVM.last?.networth ?? 0.bigNumber) - selectedAssetCapitalBigNumber

		coinInfoVM.coinPerformanceInfo = CoinPerformanceInfoValues(
			netProfit: userNetProfit.decimalString,
			ATH: allTimeHigh(chart: chart) ?? GlobalZeroAmounts.tokenAmount.zeroAmount,
			ATL: allTimeLow(chart: chart) ?? GlobalZeroAmounts.tokenAmount.zeroAmount
		)
	}

	private func allTimeHigh(chart: AssetChartViewModel) -> String? {
		let networthList = chart.chartDataEntry.map { $0.y }
		let maxNetworth = networthList.max()
		guard let maxNetworth else { return nil }
		return String(maxNetworth)
	}

	private func allTimeLow(chart: AssetChartViewModel) -> String? {
		let networthList = chart.chartDataEntry.map { $0.y }
		let minNetworth = networthList.min()
		guard let minNetworth else { return nil }
		return String(minNetworth)
	}
}
