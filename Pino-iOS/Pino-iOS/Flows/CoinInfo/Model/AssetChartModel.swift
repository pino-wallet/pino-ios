//
//  CoinInfoChartModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/19/23.
//

struct AssetChartModel: Codable {
	// MARK: - Public Properties

	public var balance: String
	public var volatilityInDollor: String
	public var volatilityPercentage: String
	public var volatilityType: String
	public var chartData: [ChartDataModel]

	enum CodingKeys: String, CodingKey {
		case balance
		case volatilityInDollor = "volatility_in_dollor"
		case volatilityPercentage = "volatility_percentage"
		case volatilityType = "volatility_type"
		case chartData = "chart_data"
	}
}
