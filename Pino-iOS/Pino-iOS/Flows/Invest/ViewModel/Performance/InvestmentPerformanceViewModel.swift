//
//  InvestmentPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Combine

class InvestmentPerformanceViewModel {
	// MARK: - Private Properties

	private var investmentAPIClient = InvestmentAPIClient()
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
		investmentAPIClient.investPortfolio(timeFrame: dateFilter.timeFrame)
			.sink { completed in
				switch completed {
				case .finished:
					print("investment performance received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0, networthDecimal: 2) }
				self.chartVM = AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter)
			}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func getShareOfAssets(assets: [InvestAssetViewModel]) {
		let userAssets = assets
			.filter { !$0.investmentAmount.isZero }
			.sorted { $0.investmentAmount > $1.investmentAmount }
		let totalAmount = userAssets.compactMap { $0.investmentAmount }.reduce(0.bigNumber, +)
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
