//
//  AssetsAmountModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

struct WalletBalanceModel: Codable {
	// MARK: - Public Properties

	public var balance: String
	public var volatilityNumber: String
	public var volatilityPercentage: String
	public var volatilityInDollor: String

	enum CodingKeys: String, CodingKey {
		case balance
		case volatilityNumber = "volatility_number"
		case volatilityPercentage = "volatility_percentage"
		case volatilityInDollor = "volatility_in_dollor"
	}
}
