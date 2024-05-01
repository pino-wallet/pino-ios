//
//  InvestViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Combine
import DGCharts
import Foundation
import PromiseKit

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

	// MARK: - Private Methods

	private func getAssets(userTokens: [AssetViewModel]) -> Promise<[InvestAssetViewModel]> {
		Promise<[InvestAssetViewModel]> { seal in
			investmentAPIClient.investments().sink { completed in
				switch completed {
				case .finished:
					print("Investments received successfully")
				case let .failure(error):
					print("Error: getting investments: \(error)")
					seal.reject(error)
				}
			} receiveValue: { investments in
				let investAssetsVM: [InvestAssetViewModel] = investments.compactMap { investment in
					guard let userToken = userTokens.first(where: { $0.id == investment.tokens.first!.tokenID })
					else { return nil }
					return InvestAssetViewModel(assetModel: investment, token: userToken)
				}
				seal.fulfill(investAssetsVM)
			}.store(in: &cancellables)
		}
	}

	private func getChartData() -> Promise<[ChartDataEntry]> {
		Promise<[ChartDataEntry]> { seal in
			investmentAPIClient.investOverallPortfolio()
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
					let chartEntries = chartDataVM.map {
						ChartDataEntry(x: $0.date.timeIntervalSinceNow, y: $0.networth.doubleValue, data: $0)
					}
					seal.fulfill(chartEntries)
				}.store(in: &cancellables)
		}
	}

	private func getInvestData(userTokens: [AssetViewModel]) -> Promise<Void> {
		let investmentsPromise = getAssets(userTokens: userTokens)
		let chartDataPromise = getChartData()
		return firstly {
			when(fulfilled: investmentsPromise, chartDataPromise)
		}.done { investments, chartDataEntries in
			self.assets = investments.sorted { $0.investmentAmount > $1.investmentAmount }
			self.chartDataEntries = chartDataEntries
			let investmentsAmount = investments.compactMap { $0.investmentAmount }.reduce(0.bigNumber, +)
			self.totalInvestments = investmentsAmount.priceFormat(of: .coin, withRule: .standard)
		}
	}

	// MARK: - Public Methods

	public func getInvestData() -> Promise<Void> {
		Promise<Void> { seal in
			GlobalVariables.shared.$manageAssetsList.sink { userTokens in
				guard SyncWalletViewModel.isSyncFinished else { return }
				if let userTokens {
					self.getInvestData(userTokens: userTokens).done { result in
						seal.fulfill(result)
					}.catch { error in
						seal.reject(error)
					}
				} else {
					self.assets = nil
					self.totalInvestments = nil
					self.chartDataEntries = nil
				}
			}.store(in: &cancellables)
		}
	}
}
