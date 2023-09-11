//
//  InvestmentDetailViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/10/23.
//

import Foundation

struct InvestmentDetailViewModel {
	// MARK: - Private Properties

	private let selectedAsset: InvestAssetViewModel

	// MARK: - Public Properties

	public let selectedProtocolTitle = "Protocol"
	public let apyTitle = "APY"
	public let investmentAmountTitle = "Investment"
	public let feeTitle = "Earned fee"
	public let totalAmountTitle = "Total amount"
	public let increaseInvestmentButtonTitle = "Increase investment"
	public let withdrawButtonTitle = "Withdraw"

	public var pageTitle: String {
		"\(assetName) investment details"
	}

	public var assetName: String {
		selectedAsset.assetName
	}

	public var assetImage: URL {
		selectedAsset.assetImage
	}

	public var assetAmount: String {
		selectedAsset.formattedTokenAmount
	}

	public var assetAmountInDollar: String {
		selectedAsset.formattedAssetAmount
	}

	public var investProtocolName: String {
		selectedAsset.assetProtocol.name
	}

	public var investProtocolImage: String {
		selectedAsset.protocolImage
	}

	public var apyAmount: String {
		"%\(selectedAsset.apyAmount)"
	}

	public var investmentAmount: String {
		selectedAsset.formattedAssetAmount
	}

	public var earnedFee: String {
		selectedAsset.formattedAssetVolatility
	}

	public var totalInvestmentAmount: String {
		let totalAmount = selectedAsset.assetAmount + selectedAsset.assetVolatility
		return totalAmount.priceFormat
	}

	public var investVolatilityType: AssetVolatilityType {
		selectedAsset.volatilityType
	}

	// MARK: Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.selectedAsset = selectedAsset
	}
}
