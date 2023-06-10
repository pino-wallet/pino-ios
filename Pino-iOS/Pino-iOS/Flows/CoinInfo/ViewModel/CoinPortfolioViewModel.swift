//
//  CoinPortfolioViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Foundation

struct CoinPortfolioViewModel {
	// MARK: - Public Properties

	public var coinPortfolioModel: AssetProtocol!

	public var showSkeletonLoading = false

	public var symbol: String {
		coinPortfolioModel.detail!.symbol
	}

	public var userAmount: BigNumber {
		BigNumber(number: coinPortfolioModel.amount, decimal: coinPortfolioModel.detail!.decimals)
	}

	public var userAmountAndCoinSymbol: String {
		"\(userAmount.formattedAmountOf(type: .hold)) \(coinPortfolioModel.detail!.symbol)"
	}

	public var logo: URL? {
		URL(string: coinPortfolioModel.detail!.logo)
	}

	public var changePercentage: String {
		coinPortfolioModel.detail!.changePercentage
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: changePercentage)
	}

	public var volatilityRatePercentage: String {
		let formattedChangePercentage = BigNumber(number: changePercentage, decimal: 2).formattedAmountOf(type: .price)
		return "\(volatilityType.prependSign)\(formattedChangePercentage)%"
	}

	public var coinPrice: BigNumber {
		BigNumber(number: coinPortfolioModel.detail!.price, decimal: 6)
	}

	public var price: String {
		"$\(coinPrice.formattedAmountOf(type: .price))"
	}

	public var type: CoinType {
		if coinPortfolioModel.detail!.isVerified {
			return CoinType.verified
		} else {
			return CoinType.unVerified
		}
	}

	public var website: String {
		#warning("this website is temporary and should be updated")
		//        return coinPortfolioModel.detail.website
		return "www.ethereum.com"
	}

	public var userAmountInDollar: String {
		let totalAmountInDollar = userAmount * coinPrice
		return "$\(totalAmountInDollar.formattedAmountOf(type: .price))"
	}

	public var isEthCoin: Bool {
		if coinPortfolioModel.detail!.id == AccountingEndpoint.ethID {
			return true
		}
		return false
	}

	public var contractAddress: String {
		if isEthCoin {
			return "-"
		} else {
			return coinPortfolioModel.detail!.id
		}
	}
}

extension CoinPortfolioViewModel {
	public enum CoinType {
		case verified
		case unVerified
		case position
	}
}
