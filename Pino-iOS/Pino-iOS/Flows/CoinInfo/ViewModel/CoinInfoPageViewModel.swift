//
//  CoinInfoPageViewModel.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/24/23.
//

import Foundation
import Network

class CoinInfoPageViewModel {
	// MARK: - Public Properties

	@Published
	public var coinInfo: CoinInfoViewModel!
	@Published
	public var historyList: [ActivityHistoryViewModel]!

	public let requestFailedErrorToastMessage = "Couldn't refresh home data"
	public let connectionErrorToastMessage = "No internet connection"

	// MARK: - Inintializers

	init() {
		getCoinInfoDetail()
		getHistoryList()
	}

	// MARK: - public Methods

	#warning("need refactore after connect to api. three funcs")
	public func refreshCoinInfoData(complition: @escaping (CoinInfoError?) -> Void) {
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
				if path.status == .satisfied {
					self.getCoinInfoDetail()
					self.getHistoryList()
					complition(nil)
					monitor.cancel()
				}
			}
		}
		let queue = DispatchQueue(label: "InternetConnectionMonitor")
		monitor.start(queue: queue)
	}

	// MARK: - private Methods

	private func getCoinInfoDetail() {
		let coinInfoModel = CoinInfoModel(
			assetImage: "BTC",
			userAmount: "12,43",
			coinAmount: "5,3",
			name: "4.98 APE",
			volatilityRate: "12,9 %",
			volatilityType: .loss,
			barrowAmount: "12,1"
		)
		coinInfo = CoinInfoViewModel(coinInfoModel: coinInfoModel)
	}

	private func getHistoryList() {
		let actionsHistoryList = [
			ActivityHistoryModel(
				activityIcon: "swap",
				activityTitle: "Swap 2.4 APE -> 200 DAI",
				time: "20 min ago",
				status: .failed
			),
			ActivityHistoryModel(
				activityIcon: "Borrow",
				activityTitle: "Borrow 1.44 APE",
				time: "1 hour ago",
				status: .success
			),
			ActivityHistoryModel(activityIcon: "send", activityTitle: "Send 2 APE", time: "3 hours ago", status: .failed),
			ActivityHistoryModel(activityIcon: "recive", activityTitle: "Receive 1.4 APE", time: "1 day ago", status: .failed),
			ActivityHistoryModel(activityIcon: "swap", activityTitle: "Swap 2.4 APE -> 200 DAI", time: "5 hours ago"),
		]

		historyList = actionsHistoryList.compactMap { ActivityHistoryViewModel(activityHistoryModel: $0) }
	}
}
