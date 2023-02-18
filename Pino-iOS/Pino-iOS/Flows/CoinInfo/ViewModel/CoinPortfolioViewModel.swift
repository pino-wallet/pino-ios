//
//  CoinPortfolioViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

struct CoinPortfolioViewModel {
	// MARK: - Public Properties

	public var coinPortfolioModel: CoinPortfolioModel!

	public var name: String {
		coinPortfolioModel.assetName
	}

	public var assetImage: String {
		coinPortfolioModel.assetImage
	}

	public var assetValue: String {
		coinPortfolioModel.assetValue
	}

	public var volatilityType: AssetVolatilityType {
        guard let volatilityType = AssetVolatilityType(rawValue: coinPortfolioModel.volatilityType) else {
            fatalError("Volitility type unknown")
        }
		return volatilityType
	}

	public var volatilityRate: String {
		"\(coinPortfolioModel.volatilityRate)%"
	}

	public var coinAmount: String {
		"$\(coinPortfolioModel.coinAmount)"
	}

	public var userAmount: String {
		"$\(coinPortfolioModel.userAmount)"
	}

	public var investAmount: String {
		"\(coinPortfolioModel.investAmount) \(name)"
	}

	public var callateralAmount: String {
		"\(coinPortfolioModel.collateralAmount) \(name)"
	}

	public var borrowAmount: String {
		"\(coinPortfolioModel.barrowAmount) \(name)"
	}
}
