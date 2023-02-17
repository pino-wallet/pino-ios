//
//  CoinInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Foundation
import Network

class CoinInfoViewModel {
	// MARK: - Public Properties

	@Published
	public var coinPortfolio: CoinPortfolioViewModel!
	@Published
	public var coinHistoryList: [CoinHistoryViewModel]!
	public let requestFailedErrorToastMessage = "Couldn't refresh coin data"
	public let connectionErrorToastMessage = "No internet connection"

	// MARK: - Inintializers

	init() {
		getCoinPortfolio()
		getHistoryList()
	}

	// MARK: - public Methods

	public func refreshCoinInfoData(completion: @escaping (CoinInfoError?) -> Void) {
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
				if path.status == .satisfied {
					self.getCoinPortfolio()
					self.getHistoryList()
					completion(nil)
				} else {
					completion(.networkingConnection)
				}
				monitor.cancel()
			}
		}
		let queue = DispatchQueue(label: "InternetConnectionMonitor")
		monitor.start(queue: queue)
	}

	// MARK: - private Methods

	private func getCoinPortfolio() {
		let coinPortfolioModel = CoinPortfolioModel(
			assetName: "4.98 COMP",
			assetImage: "COMP",
			volatilityRate: "2.77",
			volatilityType: "loss",
			coinAmount: "30,022",
			userAmount: "124,89",
			investAmount: "2",
			collateralAmount: "1.2",
			barrowAmount: "3.4"
		)
		coinPortfolio = CoinPortfolioViewModel(coinPortfolioModel: coinPortfolioModel)
	}

	private func getHistoryList() {
		let coinHistoryModelList = [
			CoinHistoryModel(
				icon: "swap",
				title: "Swap 2.4 APE -> 200 DAI",
				time: "20 min ago",
				status: "pending"
			),
			CoinHistoryModel(
				icon: "borrow",
				title: "Borrow 1.44 APE",
				time: "1 hour ago",
				status: "success"
			),
			CoinHistoryModel(
				icon: "send",
				title: "Send 2 APE",
				time: "3 hours ago",
				status: "failed"
			),
			CoinHistoryModel(
				icon: "receive",
				title: "Receive 1.4 APE",
				time: "1 day ago",
				status: "failed"
			),
			CoinHistoryModel(
				icon: "swap",
				title: "Swap 2.4 APE -> 200 DAI",
				time: "5 hours ago",
				status: "success"
			),
		]

		coinHistoryList = coinHistoryModelList.compactMap { CoinHistoryViewModel(coinHistoryModel: $0) }
	}
}
