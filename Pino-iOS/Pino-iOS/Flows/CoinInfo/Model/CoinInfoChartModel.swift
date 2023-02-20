//
//  CoinInfoChartModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

struct CoinInfoChartModel: Codable {
	// MARK: - Public Properties

	public var balance: String
	public var volatilityInDollor: String
	public var volatilityPercentage: String
	public var volatilityType: String
	public var website: String
	public var marketCap: String
	public var valume: String
	public var circulatingSupply: String
	public var totalSuply: String
	public var explorerURL: String

	enum CodingKeys: String, CodingKey {
		case balance
		case volatilityInDollor = "volatility_in_dollor"
		case volatilityPercentage = "volatility_percentage"
		case volatilityType = "volatility_type"
		case website
		case marketCap = "market_cap"
		case valume
		case circulatingSupply = "circulating_supply"
		case totalSuply = "total_suply"
		case explorerURL = "explorer_url"
	}
}
