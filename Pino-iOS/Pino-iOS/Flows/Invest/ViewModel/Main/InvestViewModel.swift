//
//  InvestViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Combine
import DGCharts
import Foundation

class InvestViewModel {
	// MARK: - Private Properties

	private let investmentAPIClient = InvestmentAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: Public Properties

	public let investmentPerformamceTitle = "Investment performance"
	public let investmentPerformanceIcon = "Invest"
	public let totalInvestmentTitle = "Total investment value"
	@Published
	public var assets: [InvestAssetViewModel]?
	@Published
	public var totalInvestments: String?
	@Published
	public var chartDataEntries: [ChartDataEntry]?

	// MARK: Initializers

	init() {
		setupBinding()
		getChartData()
	}

	// MARK: - Private Methods

	private func getAssets(userTokens: [AssetViewModel]) {
		investmentAPIClient.investments().sink { completed in
			switch completed {
			case .finished:
				print("investments received successfully")
			case let .failure(error):
				print("Error getting investments:\(error)")
			}
		} receiveValue: { investments in
			self.assets = investments.compactMap { investment in
				guard let userToken = userTokens.first(where: { $0.id == investment.tokens.first!.tokenID })
				else { return nil }
				return InvestAssetViewModel(assetModel: investment, token: userToken)
			}
			self.totalInvestments = self.assets?.compactMap { $0.investmentAmount }.reduce(0.bigNumber, +).priceFormat
		}.store(in: &cancellables)
	}

	private func getChartData() {
		investmentAPIClient.investPortfolio(timeFrame: ChartDateFilter.week.timeFrame)
			.sink { completed in
				switch completed {
				case .finished:
					print("investment performance received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { portfolio in
				let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0, networthDecimal: 2) }
				self.chartDataEntries = chartDataVM.map {
					ChartDataEntry(x: $0.date.timeIntervalSinceNow, y: $0.networth.doubleValue, data: $0)
				}
			}.store(in: &cancellables)
	}

	private func setupBinding() {
		GlobalVariables.shared.$manageAssetsList.sink { userTokens in
			if let userTokens {
				self.getAssets(userTokens: userTokens)
				self.getChartData()
			} else {
				self.assets = nil
				self.totalInvestments = nil
				self.chartDataEntries = nil
			}
		}.store(in: &cancellables)
	}
}
