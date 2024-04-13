//
//  InvestmentPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Combine
import PromiseKit

class InvestmentPerformanceViewModel {
	// MARK: - Private Properties

	private var selectedAssets: [InvestAssetViewModel]?
	private var investmentAPIClient = InvestmentAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?
	public var shareOfAssetsVM: [ShareOfAssetsProtocol]?
	public let chartDateFilterDelegate: LineChartDateFilterDelegate

	init(assets: [InvestAssetViewModel]?, chartDateFilterDelegate: LineChartDateFilterDelegate) {
		self.selectedAssets = assets
		self.chartDateFilterDelegate = chartDateFilterDelegate
	}

	// MARK: - Public Methods

	public func getInvestPerformanceData() -> Promise<Void> {
		guard let selectedAssets else { return Promise.value(()) }
		getShareOfAssets(assets: selectedAssets)
		return getChartData()
	}

	public func getChartData(dateFilter: ChartDateFilter = .day) -> Promise<Void> {
		Promise<Void> { seal in
			investmentAPIClient.investPortfolio(timeFrame: dateFilter.timeFrame)
				.sink { completed in
					switch completed {
					case .finished:
						print("Investment performance received successfully")
					case let .failure(error):
						print("Error: getting investment performance: \(error)")
						seal.reject(error)
					}
				} receiveValue: { portfolio in
					let chartDataVM = portfolio
						.compactMap { AssetChartDataViewModel(chartModel: $0, networthDecimal: 2) }
					self.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter)
					seal.fulfill(())
				}.store(in: &cancellables)
		}
	}

	// MARK: - Private Methods

	private func getShareOfAssets(assets: [InvestAssetViewModel]) {
		let userAssets = assets.sorted { $0.investmentAmount > $1.investmentAmount }
		let totalAmount = userAssets.compactMap { $0.investmentAmount }.reduce(0.bigNumber, +)
		shareOfAssetsVM = userAssets.prefix(10).compactMap {
			InvestmentShareOfAssetsViewModel(assetVM: $0, totalAmount: totalAmount)
		}
		if userAssets.count > 10 {
			shareOfAssetsVM?.append(InvestmentOtherShareOfAssetsViewModel(
				assetsVM: Array(userAssets.suffix(from: 10)),
				totalAmount: totalAmount
			))
		}
	}
}
