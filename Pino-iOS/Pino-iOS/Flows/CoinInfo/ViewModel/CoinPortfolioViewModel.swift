//
//  CoinPortfolioViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Foundation

struct CoinPortfolioViewModel {
	// MARK: - Public Properties

	public var coinPortfolioModel: CoinPortfolioModel!

	public var symbol: String {
		coinPortfolioModel.detail.symbol
	}

	public var userAmountAndCoinSymbol: String {
		"\(BigNumber(number: coinPortfolioModel.amount, decimal: coinPortfolioModel.detail.decimals).formattedAmountOf(type: .price)) \(coinPortfolioModel.detail.symbol)"
	}

	public var logo: URL? {
		URL(string: coinPortfolioModel.detail.logo)
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: coinPortfolioModel.detail.change24H)
	}

	public var volatilityRatePercentage: String {
		"\(volatilityType.prependSign)\(BigNumber(number: coinPortfolioModel.detail.changePercentage, decimal: 2).formattedAmountOf(type: .price))%"
	}

	public var price: String {
		"$\(BigNumber(number: coinPortfolioModel.detail.price, decimal: 6).formattedAmountOf(type: .price))"
	}

	public var type: CoinType {
		CoinType.verified
	}

	public var website: String {
		#warning("this website is temporary and should be updated")
		//        return coinPortfolioModel.detail.website
		return "www.ethereum.com"
	}

	public var userAmountInDollar: String {
		let userAmount = BigNumber(number: coinPortfolioModel.amount, decimal: coinPortfolioModel.detail.decimals)
		let coinPrice = BigNumber(number: coinPortfolioModel.detail.price, decimal: 6)
		let totalAmountInDollar = userAmount * coinPrice
		return totalAmountInDollar.formattedAmountOf(type: .hold)
	}

	public var contractAddress: String {
		if coinPortfolioModel.detail.id == AssetsEndpoint.ethID {
			return "-"
		}
		return coinPortfolioModel.detail.id
	}
}

extension CoinPortfolioViewModel {
	public enum CoinType {
		case verified
		case unVerified
		case position
	}
}
