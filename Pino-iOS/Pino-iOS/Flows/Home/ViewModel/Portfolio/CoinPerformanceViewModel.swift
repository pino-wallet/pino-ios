//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//
import Combine
import DGCharts
import Foundation
import PromiseKit

class CoinPerformanceViewModel {
	// MARK: - Private Properties

	private var accountingAPIClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let selectedAsset: AssetViewModel

	// MARK: - Public Properties

	public let assetName: String
	public var navigationTitle: String {
		"\(assetName) performance"
	}

	public let assetImage: URL
	@Published
	public var chartVM: AssetChartViewModel?
	public var coinInfoVM = CoinPerformanceInfoViewModel()

	// MARK: - Initializers

	init(selectedAsset: AssetViewModel) {
		self.selectedAsset = selectedAsset
		self.assetName = selectedAsset.symbol
		self.assetImage = selectedAsset.image
	}

	// MARK: - Public Methods

	public func getCoinPerformance() -> Promise<Void> {
		firstly {
			getChartData()
		}.then { assetChartVM in
			self.getAllTimePerformance().map { (assetChartVM, $0) }
		}.done { [weak self] assetChartVM, tokenAllTime in
			guard let self else { return }
			chartVM = assetChartVM
			coinInfoVM.updateNetProfit(assetChartVM.chartDataVM, selectedAsset: selectedAsset)
			coinInfoVM.updateTokenAllTime(tokenAllTime, selectedAsset: selectedAsset)
		}
	}

	public func getChartData(dateFilter: ChartDateFilter) -> Promise<Void> {
		getChartData(dateFilter: dateFilter).done { [weak self] assetChartVM in
			self?.chartVM = assetChartVM
		}
	}

	// MARK: - Private Methods

	private func getChartData(dateFilter: ChartDateFilter = .day) -> Promise<AssetChartViewModel> {
		Promise<AssetChartViewModel> { seal in
			accountingAPIClient.coinPerformance(timeFrame: dateFilter.timeFrame, tokenID: selectedAsset.id)
				.sink { completed in
					switch completed {
					case .finished:
						print("Coin performance received successfully")
					case let .failure(error):
						print("Error: getting coin performance: \(error.description)")
						seal.reject(error)
					}
				} receiveValue: { portfolio in
					let chartDataVM = portfolio.compactMap { AssetChartDataViewModel(chartModel: $0) }
					seal.fulfill(AssetChartViewModel(chartDataVM: chartDataVM, dateFilter: dateFilter))
				}.store(in: &cancellables)
		}
	}

	private func getAllTimePerformance() -> Promise<TokenAllTimePerformance> {
		Promise<TokenAllTimePerformance> { seal in
			accountingAPIClient.getAllTimePerformanceOf(selectedAsset.id).sink { completed in
				switch completed {
				case .finished:
					print("Coin all time recieved successfully")
				case let .failure(error):
					print("Error: getting coin all time: \(error.description)")
					seal.reject(error)
				}
			} receiveValue: { tokenAllTime in
				seal.fulfill(tokenAllTime)
			}.store(in: &cancellables)
		}
	}
}
