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

	public func formattedPriceImpact(_ priceImpact: String) -> String {
		"%\(priceImpact)"
	}

	public func formattedSaveAmount(_ saveAmount: String) -> String {
		"$\(saveAmount) \(celebrateEmoji)"
	}

	public func formattedFee(_ fee: String) -> String {
		"\(fee) ETH"
	}

	public func formattedFeeInDollar(_ fee: String) -> String {
		"$\(fee)"
	}
}

extension SwapFeeViewModel {
	public enum FeeTag {
		case highImpact
		case save(String)
		case none
	}
}
