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
        var formattedUserAmount: String
        if userAmount.isZero {
            formattedUserAmount = GlobalZeroAmounts.tokenAmount.zeroAmount
        } else {
            formattedUserAmount = userAmount.sevenDigitFormat
        }
		return "\(formattedUserAmount) \(coinPortfolioModel.detail!.symbol)"
	}

	public var logo: URL? {
		URL(string: coinPortfolioModel.detail!.logo)
	}

	public var changePercentage: String {
		coinPortfolioModel.detail!.changePercentage
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: BigNumber(number: changePercentage, decimal: 6))
	}

	public var volatilityRatePercentage: String {
		let formattedChangePercentage = BigNumber(number: changePercentage, decimal: 2)
        if formattedChangePercentage.isZero {
            return GlobalZeroAmounts.percentage.zeroAmount
        }
		return "\(volatilityType.prependSign)\(formattedChangePercentage)%"
	}

	public var coinPrice: BigNumber {
		BigNumber(number: coinPortfolioModel.detail!.price, decimal: 6)
	}

	public var price: String {
		coinPrice.priceFormat
	}

	public var type: CoinType {
		if coinPortfolioModel.detail!.isVerified {
			return CoinType.verified
		} else {
			return CoinType.unVerified
		}
	}

	public var website: String {
        let websiteURL = URL(string: coinPortfolioModel.detail!.website)
        return (websiteURL!.host ?? coinPortfolioModel.detail?.website) ?? "-"
	}

	public var userAmountInDollar: String {
		let totalAmountInDollar = userAmount * coinPrice
		return totalAmountInDollar.priceFormat
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

	public var formattedContractAddress: String {
		if isEthCoin {
			return "-"
		} else {
			return coinPortfolioModel.detail!.id.addressFormating()
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
