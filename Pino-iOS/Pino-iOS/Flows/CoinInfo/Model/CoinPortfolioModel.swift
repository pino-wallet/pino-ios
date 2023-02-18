//
//  CoinPortfolioModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

struct CoinPortfolioModel: Codable {
	// MARK: - public properties

	public var id: String
	public var assetName: String
	public var assetImage: String
	public var assetValue: String
	public var volatilityRate: String
	public var volatilityType: String
	public var coinAmount: String
	public var userAmount: String
	public var investAmount: String
	public var collateralAmount: String
	public var barrowAmount: String

	enum CodingKeys: String, CodingKey {
		case id
		case assetName = "asset_name"
		case assetImage = "asset_image"
		case assetValue = "asset_value"
		case volatilityRate = "volatility_rate"
		case volatilityType = "volatility_type"
		case coinAmount = "coin_amount"
		case userAmount = "user_amount"
		case investAmount = "invest_amount"
		case collateralAmount = "collateral_amount"
		case barrowAmount = "barrow_amount"
	}
}
