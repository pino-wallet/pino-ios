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
		chartDataEntries = [
			ChartDataEntry(x: 0, y: 0),
			ChartDataEntry(x: 1, y: 0.5),
			ChartDataEntry(x: 2, y: 0.2),
			ChartDataEntry(x: 3, y: 2),
			ChartDataEntry(x: 4, y: 1),
			ChartDataEntry(x: 5, y: 3),
			ChartDataEntry(x: 6, y: 1.3),
			ChartDataEntry(x: 7, y: 3),
			ChartDataEntry(x: 8, y: 1.5),
			ChartDataEntry(x: 9, y: 4),
			ChartDataEntry(x: 10, y: 0.5),
			ChartDataEntry(x: 11, y: 4),
		]
	}

	private func setupBinding() {
		if let userTokens = GlobalVariables.shared.manageAssetsList {
			getAssets(userTokens: userTokens)
		} else {
			GlobalVariables.shared.$manageAssetsList.compactMap { $0 }.sink { userTokens in
				if self.assets == nil {
					self.getAssets(userTokens: userTokens)
				}
			}.store(in: &cancellables)
		}
	}
}
