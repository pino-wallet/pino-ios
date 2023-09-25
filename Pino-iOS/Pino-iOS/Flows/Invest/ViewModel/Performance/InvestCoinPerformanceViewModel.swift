//
//  InvestCoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Charts
import Combine
import Foundation

class InvestCoinPerformanceViewModel {
	// MARK: - Private Properties

	private var investmentAPIClient = InvestmentAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let selectedAsset: InvestAssetViewModel

	// MARK: - Public Properties

	public let assetName: String
	public let assetImage: URL
	public let protocolImage: String
	@Published
	public var chartVM: AssetChartViewModel?
	public var coinInfoVM = CoinPerformanceInfoViewModel()

	// MARK: - Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.selectedAsset = selectedAsset
		self.assetName = selectedAsset.assetName
		self.assetImage = selectedAsset.assetImage
		self.protocolImage = selectedAsset.assetProtocol.image
		getChartData()
		setupBindings()
	}

	// MARK: - Private Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) {
		investmentAPIClient.investmentPerformance(
			timeFrame: dateFilter.timeFrame,
			investmentID: "0x0659860901f0ae79fcdbf5d032f7cb62bb7ac18788570d5887fb5db863279a30"
		)
		.sink { completed in
			switch completed {
			case .finished:
				print("Coin performance received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { portfolio in
			let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0, networthDecimal: 2) }
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
		coinInfoVM.coinPerformanceInfo = CoinPerformanceInfoValues(
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
