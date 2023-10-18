//
//  SwapFeeViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/4/23.
//

import Foundation

class SwapFeeViewModel {
	// MARK: Public Properties

	@Published
	public var calculatedAmount: String?
	@Published
	public var feeTag: FeeTag = .none
	@Published
	public var swapProviderVM: SwapProviderViewModel?
	@Published
	public var saveAmount: String?
	@Published
	public var priceImpact: String?
	@Published
	public var fee: String?
	@Published
	public var feeInDollar: String?
	@Published
	public var isBestRate = false

	public var priceImpactStatus: PriceImpactStatus = .normal

	public let highImpactTagTitle = "High impact"
	public let saveAmountTitle = "You save"
	public let providerTitle = "Provider"
	public let priceImpactTitle = "Price impact"
	public let feeTitle = "Fee"
	public let celebrateEmoji = "🎉"
	public let loadingText = "Fetching the best price"

	// MARK: - Initializers

	init(swapProviderVM: SwapProviderViewModel? = nil) {
		self.swapProviderVM = swapProviderVM
	}

	// MARK: - Public Methods

	public func formattedSaveAmount(_ saveAmount: String) -> String {
		"\(saveAmount.currencyFormatting) \(celebrateEmoji)"
	}

	#warning("There is a bug here in high amounts calculation that becomes 0. (1 ETH = 0 USDT)")
	public func updateQuote(srcToken: SwapTokenViewModel, destToken: SwapTokenViewModel) {
		if let srcAmount = srcToken.tokenAmount, let destAmount = destToken.tokenAmount {
			let formattedFromTokenAmount = "1 \(srcToken.selectedToken.symbol)"
			let formattedToTokenAmount: String
			if let toTokenAmount = BigNumber(numberWithDecimal: destAmount) / BigNumber(numberWithDecimal: srcAmount) {
				formattedToTokenAmount = toTokenAmount.sevenDigitFormat
					.tokenFormatting(token: destToken.selectedToken.symbol)
			} else {
				formattedToTokenAmount = "0 \(destToken.selectedToken.symbol)"
			}
			calculatedAmount = "\(formattedFromTokenAmount) = \(formattedToTokenAmount)"
		} else {
			calculatedAmount = nil
		}
	}

	public func calculatePriceImpact(srcTokenAmount: BigNumber?, destTokenAmount: BigNumber?) {
		guard let srcTokenAmount, let destTokenAmount else { return }
		let differenceOfTokensAmount = srcTokenAmount - destTokenAmount
		let priceImpactBigNumber = (differenceOfTokensAmount / srcTokenAmount)! * 100.bigNumber
		getPriceImpactStatus(priceImpactBigNumber)
		if priceImpactBigNumber < 0.bigNumber {
			priceImpact = "0"
		} else {
			priceImpact = priceImpactBigNumber.percentFormat
		}
	}

	public func getPriceImpactStatus(_ priceImpactNumber: BigNumber) {
		switch priceImpactNumber {
		case _ where priceImpactNumber > 1.bigNumber:
			priceImpactStatus = .veryHigh
		case _ where priceImpactNumber < BigNumber(numberWithDecimal: "0.1"):
			priceImpactStatus = .low
		case _ where priceImpactNumber < 1.bigNumber && priceImpactNumber > BigNumber(numberWithDecimal: "0.1"):
			priceImpactStatus = .high
		default: break
		}
	}
}

extension SwapFeeViewModel {
	public enum FeeTag {
		case highImpact
		case save(String)
		case none
	}

	public enum PriceImpactStatus {
		case normal
		case low
		case high
		case veryHigh
	}
}
