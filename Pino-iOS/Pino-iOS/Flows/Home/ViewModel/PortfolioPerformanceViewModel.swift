//
//  PortfolioPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Combine

class PortfolioPerformanceViewModel {
	// MARK: - Private Properties

	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?
	public var shareOfAssetsVM: [ShareOfAssetsViewModel]!

	// MARK: - Initializers

	init(assets: [AssetViewModel]) {
		getChartData()
		getShareOfAssets(assets: assets)
	}

	// MARK: - Public Methods

	public func getChartData(dateFilter: ChartDateFilter = .hour) {
		accountingAPIClient.userPortfolio(timeFrame: dateFilter.timeFrame)
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

	// MARK: - Private Methods

	private func getShareOfAssets(assets: [AssetViewModel]) {
		let userAssets = assets.filter { !$0.holdAmount.isZero }
		let totalAmount = userAssets.map { $0.holdAmountInDollorNumber }.reduce(BigNumber(number: 0, decimal: 0), +)
		shareOfAssetsVM = userAssets.compactMap { ShareOfAssetsViewModel(assetVM: $0, totalAmount: totalAmount) }
	}
}
