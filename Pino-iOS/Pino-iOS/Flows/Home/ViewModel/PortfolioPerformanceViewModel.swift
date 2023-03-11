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
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel!
	public var shareOfAssetsVM: [ShareOfAssetsViewModel]!

	// MARK: - Initializers

	init() {
		getChartData()
		getShareOfAssets()
	}

	// MARK: - Public Methods

	public func updateChartData(by dateFilter: ChartDateFilter) {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("Chart info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModelList in
			var chartModel: AssetChartModel
			#warning("It is temporary and must be replaced by API data")
			switch dateFilter {
			case .hour:
				chartModel = chartModelList[0]
			case .day:
				chartModel = chartModelList[1]
			case .week:
				chartModel = chartModelList[2]
			case .month:
				chartModel = chartModelList[3]
			case .year:
				chartModel = chartModelList[4]
			case .all:
				chartModel = chartModelList[5]
			}
			self?.chartVM = AssetChartViewModel(chartModel: chartModel, dateFilter: dateFilter)
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func getChartData() {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("Chart info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModelList in
			self?.chartVM = AssetChartViewModel(chartModel: chartModelList.first!, dateFilter: .hour)
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
