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

	public var formattedSaveAmount: String? {
		guard let saveAmount else { return nil }
		return "$\(saveAmount) \(celebrateEmoji)"
	}

	public var formattedPriceImpact: String? {
		guard let priceImpact else { return nil }
		return "%\(priceImpact)"
	}

	public var formattedFee: String? {
		guard let fee else { return nil }
		return "\(fee) ETH"
	}

	public var formattedFeeInDollar: String? {
		guard let fee else { return nil }
		return "$\(fee)"
	}

	// MARK: - Initializers

	init(swapProviderVM: SwapProviderViewModel? = nil) {
		self.swapProviderVM = swapProviderVM
	}
}

extension SwapFeeViewModel {
	public enum FeeTag {
		case highImpact
		case save(String)
		case none
	}
}
