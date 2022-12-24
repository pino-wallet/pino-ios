//
//  WalletBalanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

struct WalletBalanceViewModel {
	// MARK: - Public Properties

	public var walletBalance: WalletBalanceModel!

	public var balance: String {
		"$ \(walletBalance.balance)"
	}

	public var volatilityPercentage: String
	public var volatilityInDollor: String
	public var volatilityType: AssetVolatilityType
}
