//
//  CoinPortfolioViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

struct CoinPortfolioViewModel {
	// MARK: - Public Properties

	public var coinPortfolioModel: CoinPortfolioModel!

	public var assetImage: String {
		coinPortfolioModel.assetImage
	}

	public var userAmount: String {
		"$\(coinPortfolioModel.userAmount)"
	}

	public var coinAmount: String {
		"$\(coinPortfolioModel.coinAmount)"
	}

	public var name: String {
		coinPortfolioModel.assetName
	}

	public var volatilityRate: String {
		"\(coinPortfolioModel.volatilityRate)%"
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
