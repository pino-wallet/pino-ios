//
//  AssetsAmountModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

struct WalletBalanceModel: Codable {
	// MARK: - Public Properties

	public var balance: String
	public var volatilityPercentage: String
	public var volatilityInDollor: String
	public var volatilityType: String
}
