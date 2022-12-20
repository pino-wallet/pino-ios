//
//  AssetsAmountModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

struct WalletBalanceModel {
	// MARK: - Public Properties

	public var amount: String
	public var volatilityPercentage: String
	public var volatilityInDollor: String
	public var volatilityType: VolatilityType

	enum VolatilityType {
		case profit
		case loss
	}
}
