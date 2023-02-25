//
//  AboutCoinModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//

struct AboutCoinModel: Codable {
	// MARK: - public properties

	public var website: String
	public var marketCap: String
	public var valume: String
	public var circulatingSupply: String
	public var totalSuply: String
	public var explorerURL: String

	enum CodingKeys: String, CodingKey {
		case website
		case marketCap = "market_cap"
		case valume
		case circulatingSupply = "circulating_supply"
		case totalSuply = "total_suply"
		case explorerURL = "explorer_url"
	}
}
