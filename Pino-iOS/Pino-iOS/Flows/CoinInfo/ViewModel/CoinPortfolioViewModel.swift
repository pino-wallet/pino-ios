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
		AssetVolatilityType(change24h: BigNumber(number: changePercentage, decimal: 2))
	}

	public var volatilityRatePercentage: String? {
		guard let selectedTokenDetails = coinPortfolioModel.detail else {
			return nil
		}
		if selectedTokenDetails.isVerified && !selectedTokenDetails.isPosition {
			let formattedChangePercentage = BigNumber(number: changePercentage, decimal: 2)
			if formattedChangePercentage.isZero {
				return GlobalZeroAmounts.percentage.zeroAmount
			}
			if formattedChangePercentage.number.sign == .plus {
				return "\(volatilityType.prependSign)\(formattedChangePercentage.percentFormat)%"
			} else {
				return "\(formattedChangePercentage.percentFormat)%"
			}
		} else {
			return nil
		}
	}

	public var coinPrice: BigNumber {
		BigNumber(number: coinPortfolioModel.detail!.price, decimal: Web3Core.Constants.pricePercision)
	}

	public var price: String {
		coinPrice.priceFormat
	}

	public var type: CoinType {
		if coinPortfolioModel.detail!.isPosition {
			return CoinType.position
		}
		if coinPortfolioModel.detail!.isVerified {
			return CoinType.verified
		} else {
			return CoinType.unVerified
		}
	}

	public var website: String {
		let websiteURL = URL(string: coinPortfolioModel.detail!.website)
		return (websiteURL!.host ?? coinPortfolioModel.detail?.website)?
			.replacingOccurrences(of: "www.", with: "") ?? "-"
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
