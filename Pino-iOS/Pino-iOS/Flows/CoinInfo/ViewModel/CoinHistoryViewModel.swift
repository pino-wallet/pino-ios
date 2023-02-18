//
//  CoinHistoryViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

struct CoinHistoryViewModel {
	// MARK: - Public Properties

	public var coinHistoryModel: CoinHistoryModel!

	public var icon: String {
		coinHistoryModel.icon
	}

	public var title: String {
		coinHistoryModel.title
	}

	public var time: String {
		coinHistoryModel.time
	}

	public var status: HistoryStatus {
		HistoryStatus(rawValue: coinHistoryModel.status) ?? .success
	}
}
