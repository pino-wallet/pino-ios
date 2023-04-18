//
//  CoinPortfolioModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

struct CoinPortfolioModel: Codable {
	// MARK: - public properties

	public let id, amount, hold, investment: String
	public let isVerified: Bool
	public let detail: Detail

	public enum CodingKeys: String, CodingKey {
		case id
		case amount
		case hold
		case investment
		case isVerified = "is_verified"
		case detail
	}
}

extension CoinInfoViewModel {
	struct Detail: Codable {
		public let id, symbol, name: String
		public let logo: String
		public let decimals: Int
		public let change24H, changePercentage, price: String

		public enum CodingKeys: String, CodingKey {
			case id
			case symbol
			case name
			case logo
			case decimals
			case change24H = "change_24h"
			case changePercentage = "change_percentage"
			case price
		}
	}
}
