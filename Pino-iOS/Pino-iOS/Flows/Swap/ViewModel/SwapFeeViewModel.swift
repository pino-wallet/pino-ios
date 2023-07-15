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

	public let highImpactTagTitle = "High impact"
	public let saveAmountTitle = "You save"
	public let providerTitle = "Provider"
	public let priceImpactTitle = "Price impact"
	public let feeTitle = "Fee"
	public let celebrateEmoji = "🎉"

	// MARK: - Initializers

	init(swapProviderVM: SwapProviderViewModel? = nil) {
		self.swapProviderVM = swapProviderVM
	}

	// MARK: - Public Methods

	public func formattedSaveAmount(_ saveAmount: String) -> String {
		"\(saveAmount.currencyFormatting) \(celebrateEmoji)"
	}

	public func updateAmount(fromToken: SwapTokenViewModel, toToken: SwapTokenViewModel) {
		if let fromTokenAmount = fromToken.tokenAmount, let toTokenAmount = toToken.tokenAmount {
			let formattedFromTokenAmount = fromTokenAmount.tokenFormatting(token: fromToken.selectedToken.symbol)
			let formattedToTokenAmount = toTokenAmount.tokenFormatting(token: toToken.selectedToken.symbol)
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
