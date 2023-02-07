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
	public var historyList: [ActionHistoryViewModel]!

	public let requestFailedErrorToastMessage = "Couldn't refresh home data"
	public let connectionErrorToastMessage = "No internet connection"

	// MARK: - Inintializers

	init() {
		getCoinInfoDetail()
		getHistoryList()
	}

	// MARK: - public Methods

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
			changingRate: "12,9 %",
			changingRateType: .decrease,
			barrowAmount: "12,1"
		)
		coinInfo = CoinInfoViewModel(coinInfoModel: coinInfoModel)
	}

	private func getHistoryList() {
		let actionsHistoryList = [
			ActionHistoryModel(
				actionIcon: "swap",
				actionTitle: "Swap 2.4 APE -> 200 DAI",
				time: "20 min ago",
				status: .pending
			),
			ActionHistoryModel(
				actionIcon: "Borrow",
				actionTitle: "Borrow 1.44 APE",
				time: "1 hour ago",
				status: .success
			),
			ActionHistoryModel(actionIcon: "send", actionTitle: "Send 2 APE", time: "3 hours ago", status: .failed),
			ActionHistoryModel(actionIcon: "recive", actionTitle: "Receive 1.4 APE", time: "1 day ago", status: .failed),
		]

		historyList = actionsHistoryList.compactMap { ActionHistoryViewModel(actionHistoryModel: $0) }
	}
}
