//
//  PortfolioPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Combine
import PromiseKit

class PortfolioPerformanceViewModel {
	// MARK: - Private Properties

	private let selectedAssets: [AssetViewModel]
	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?
	public var shareOfAssetsVM: [ShareOfAssetsProtocol]?
	public let chartDateFilterDelegate: LineChartDateFilterDelegate

	// MARK: - Initializers

	init(assets: [AssetViewModel], chartDateFilterDelegate: LineChartDateFilterDelegate) {
		self.selectedAssets = assets
		self.chartDateFilterDelegate = chartDateFilterDelegate
	}

	// MARK: - Public Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) -> Promise<Void> {
		Promise<Void> { seal in
			let tokensId = selectedAssets.map { $0.id.lowercased() }
			accountingAPIClient.userPortfolio(timeFrame: dateFilter.timeFrame, tokensId: tokensId)
				.sink { completed in
					switch completed {
					case .finished:
						print("Portfolio performance received successfully")
					case let .failure(error):
						print("Error: getting portfolio performance: \(error.description)")
						seal.reject(error)
					}
				} receiveValue: { portfolio in
					let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0) }
					self.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter)
				}.store(in: &cancellables)
		}
	}

	public func getPortfolioPerformanceData() -> Promise<Void> {
		getShareOfAssets()
		return getChartData()
	}

	// MARK: - Private Methods

	private func getShareOfAssets() {
		let userAssets = selectedAssets.sorted { $0.holdAmountInDollor > $1.holdAmountInDollor }
		let totalAmount = userAssets.compactMap { $0.holdAmountInDollor }.reduce(0.bigNumber, +)
		shareOfAssetsVM = userAssets.prefix(10).compactMap {
			ShareOfAssetsViewModel(assetVM: $0, totalAmount: totalAmount)
		}
		if userAssets.count > 10 {
			shareOfAssetsVM?.append(OtherShareOfAssetsViewModel(
				assetsVM: Array(userAssets.suffix(from: 10)),
				totalAmount: totalAmount
			))
		}
	}
}
