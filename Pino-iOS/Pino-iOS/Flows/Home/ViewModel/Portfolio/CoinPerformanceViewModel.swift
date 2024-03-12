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

	public func getChartData(dateFilter: ChartDateFilter) {
		getChartData(dateFilter: dateFilter).done { [weak self] assetChartVM in
			self?.chartVM = assetChartVM
		}.catch { [weak self] error in
			self?.showError(error)
		}
	}

	// MARK: - Private Methods

	private func getChartData(dateFilter: ChartDateFilter = .day) -> Promise<AssetChartViewModel> {
		Promise<AssetChartViewModel> { seal in
			accountingAPIClient.coinPerformance(timeFrame: dateFilter.timeFrame, tokenID: selectedAsset.id)
				.sink { completed in
					switch completed {
					case .finished:
						print("Portfolio received successfully")
					case let .failure(error):
						print(error)
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
					print("ATL and ATH recieved successfully")
				case let .failure(error):
					print(error)
					seal.reject(error)
				}
			} receiveValue: { tokenAllTime in
				seal.fulfill(tokenAllTime)
			}.store(in: &cancellables)
		}
	}

	private func showError(_ error: Error) {
		Toast.default(
			title: "\(error.localizedDescription)",
			subtitle: GlobalToastTitles.tryAgainToastTitle.message,
			style: .error
		)
		.show(haptic: .warning)
	}

	// MARK: - Public Methods

	public func getCoinPerformance() {
		firstly {
			getChartData()
		}.then { assetChartVM in
			self.getAllTimePerformance().map { (assetChartVM, $0) }
		}.done { [weak self] assetChartVM, tokenAllTime in
			guard let self else { return }
			chartVM = assetChartVM
			coinInfoVM.updateNetProfit(assetChartVM.chartDataVM, selectedAssetCapital: selectedAsset.assetCapital)
			coinInfoVM.updateTokenAllTime(tokenAllTime)
		}.catch { [weak self] error in
			self?.showError(error)
		}
	}
}
