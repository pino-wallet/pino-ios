//
//  CoinInfoChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

import Charts
import Combine

class CoinInfoChartViewModel {
	// MARK: - Private Properties

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel!
	public var aboutCoinVM: AboutCoinViewModel!

	// MARK: - Initializers

	init() {
		getChartData()
		getAboutCoin()
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
		} receiveValue: { [weak self] chartModel in
			self?.chartVM = AssetChartViewModel(chartModel: chartModel, dateFilter: .hour)
		}.store(in: &cancellables)
	}

	private func getAboutCoin() {
		assetsAPIClient.aboutCoin().sink { completed in
			switch completed {
			case .finished:
				print("Coin info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] aboutCoin in
			self?.aboutCoinVM = AboutCoinViewModel(aboutCoin: aboutCoin)
		}.store(in: &cancellables)
	}

	public func updateChartData(by dateFilter: ChartDateFilter) {
		assetsAPIClient.coinInfoChart().sink { completed in
			switch completed {
			case .finished:
				print("Chart info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] chartModel in
			self?.chartVM = AssetChartViewModel(chartModel: chartModel, dateFilter: dateFilter)
		}.store(in: &cancellables)
	}
}
