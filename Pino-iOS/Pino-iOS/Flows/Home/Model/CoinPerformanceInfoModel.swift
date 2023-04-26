//
//  CoinPerformanceModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//
struct CoinPerformanceInfoModel: Codable {
	public var netProfit: String
	public var allTimeHigh: String
	public var allTimeLow: String

	enum CodingKeys: String, CodingKey {
		case netProfit = "net_profit"
		case allTimeHigh = "all_time_high"
		case allTimeLow = "all_time_low"
	}
}
