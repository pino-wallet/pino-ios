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
	public var shareOfAssetsVM: [ShareOfAssetsProtocol]!

	// MARK: - Initializers

	init(assets: [AssetViewModel]) {
		getChartData()
		getShareOfAssets(assets: assets)
	}

	// MARK: - Public Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) {
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
		let userAssets = assets
			.filter { !$0.holdAmount.isZero }
			.sorted { $0.holdAmountInDollor.doubleValue > $1.holdAmountInDollor.doubleValue }
		let totalAmount = userAssets.compactMap { $0.holdAmountInDollor.doubleValue }.reduce(0.0, +)
		shareOfAssetsVM = userAssets.prefix(10).compactMap {
			ShareOfAssetsViewModel(assetVM: $0, totalAmount: totalAmount)
		}
		if userAssets.count > 10 {
			shareOfAssetsVM.append(OtherShareOfAssetsViewModel(
				assetsVM: Array(userAssets.suffix(from: 10)),
				totalAmount: totalAmount
			))
		}
	}
}
