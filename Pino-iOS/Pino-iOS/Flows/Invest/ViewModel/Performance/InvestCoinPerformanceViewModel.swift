//
//  InvestCoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Combine
import DGCharts
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
	public var pageTitle: String {
		"\(assetName) performance"
	}

	// MARK: - Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.selectedAsset = selectedAsset
		self.assetName = selectedAsset.assetName
		self.assetImage = selectedAsset.assetImage
		self.protocolImage = selectedAsset.assetProtocol.image
		getChartData()
		getCoinPerformanceInfo()
	}

	// MARK: - Private Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) {
		investmentAPIClient.investmentPerformance(
			timeFrame: dateFilter.timeFrame,
			investmentID: selectedAsset.investmentId
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

	private func getCoinPerformanceInfo() {
		let allTimeFrame = ChartDateFilter.all.timeFrame
		investmentAPIClient.investmentPerformance(timeFrame: allTimeFrame, investmentID: selectedAsset.investmentId)
			.sink { completed in
				switch completed {
				case .finished:
					print("Coin performance received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0, networthDecimal: 2) }
				self.coinInfoVM.updateAllTimeHigh(chartDataVM)
				self.coinInfoVM.updateAllTimelow(chartDataVM)
				self.coinInfoVM.updateNetProfit(chartDataVM, selectedAsset: self.selectedAsset.investToken)
			}.store(in: &cancellables)
	}
}
