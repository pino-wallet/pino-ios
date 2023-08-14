//
//  InvestmentPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Combine

class InvestmentPerformanceViewModel {
	// MARK: - Private Properties

	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?
	public var shareOfAssetsVM: [ShareOfAssetsProtocol]!

	// MARK: - Initializers

	init(assets: [InvestAssetViewModel]) {
		getChartData()
		getShareOfAssets(assets: assets)
	}

	// MARK: - Public Methods

	public func getChartData(dateFilter: ChartDateFilter = .day) {
		#warning("The investmnet data is currently empty, portfolio data is used temporarily for test")
		accountingAPIClient.userPortfolio(timeFrame: dateFilter.timeFrame)
			.sink { completed in
				switch completed {
				case .finished:
					print("investment performance received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0) }
				self.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter)
			}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func getShareOfAssets(assets: [InvestAssetViewModel]) {
		let userAssets = assets
			.filter { !$0.assetAmount.isZero }
			.sorted { $0.assetAmount > $1.assetAmount }
		let totalAmount = userAssets.compactMap { $0.assetAmount }.reduce(0.bigNumber, +)
		shareOfAssetsVM = userAssets.prefix(10).compactMap {
			InvestmentShareOfAssetsViewModel(assetVM: $0, totalAmount: totalAmount)
		}
		if userAssets.count > 10 {
			shareOfAssetsVM.append(InvestmentOtherShareOfAssetsViewModel(
				assetsVM: Array(userAssets.suffix(from: 10)),
				totalAmount: totalAmount
			))
		}
	}
}
