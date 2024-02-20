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
				self.coinInfoVM.updateAllTimeHigh(chartDataVM)
				self.coinInfoVM.updateAllTimelow(chartDataVM)
				self.coinInfoVM.updateNetProfit(chartDataVM, selectedAssetCapital: self.selectedAsset.assetCapital)
			}.store(in: &cancellables)
	}
}
