//
//  PortfolioPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Combine

class PortfolioPerformanceViewModel {
	// MARK: - Private Properties

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?
	public var shareOfAssetsVM: [ShareOfAssetsViewModel]!

	// MARK: - Initializers

	init() {
		getChartData()
		getShareOfAssets()
	}

	// MARK: - Public Methods

	public func updateChartData(by dateFilter: ChartDateFilter) {
		accountingAPIClient.userPortfolio(timeFrame: dateFilter.timeFrame)
			.sink { completed in
				switch completed {
				case .finished:
					print("Portfolio received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				self.chartVM = AssetChartViewModel(chartData: portfolio, dateFilter: dateFilter)
			}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func getChartData() {
		let dateFilter = ChartDateFilter.hour
		accountingAPIClient.userPortfolio(timeFrame: dateFilter.timeFrame)
			.sink { completed in
				switch completed {
				case .finished:
					print("Portfolio received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				self.chartVM = AssetChartViewModel(chartData: portfolio, dateFilter: dateFilter)
			}.store(in: &cancellables)
	}

	private func getShareOfAssets() {
		assetsAPIClient.assets().sink { completed in
			switch completed {
			case .finished:
				print("Share of assets received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] assets in
			self?.shareOfAssetsVM = assets.assetsList.compactMap { ShareOfAssetsViewModel(assetModel: $0) }
		}.store(in: &cancellables)
	}
}
