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

	#warning("Amount calculation based on price is temporary and must be replaced with api data")
	public func updateAmount(fromToken: SwapTokenViewModel, toToken: SwapTokenViewModel) {
		if fromToken.tokenAmount != nil, toToken.tokenAmount != nil {
			let formattedFromTokenAmount = "1 \(fromToken.selectedToken.symbol)"
			let formattedToTokenAmount: String
			if let toTokenAmount = fromToken.selectedToken.price / toToken.selectedToken.price {
				formattedToTokenAmount = toTokenAmount.sevenDigitFormat
					.tokenFormatting(token: toToken.selectedToken.symbol)
			} else {
				formattedToTokenAmount = "0 \(toToken.selectedToken.symbol)"
			}
			calculatedAmount = "\(formattedFromTokenAmount) = \(formattedToTokenAmount)"
		} else {
			calculatedAmount = nil
		}
	}
}

extension SwapFeeViewModel {
	public enum FeeTag {
		case highImpact
		case save(String)
		case none
	}
}
