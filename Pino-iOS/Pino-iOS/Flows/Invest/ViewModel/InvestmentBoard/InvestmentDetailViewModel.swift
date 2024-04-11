//
//  InvestmentDetailViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/10/23.
//

import Combine
import Foundation

class InvestmentDetailViewModel {
	// MARK: - Private Properties

	private let selectedAsset: InvestAssetViewModel
	private let investmentAPIClient = InvestmentAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let selectedProtocolTitle = "Protocol"
	public let apyTitle = "APY"
	public let investmentAmountTitle = "Investment"
	public let feeTitle = "Earned fee"
	public let totalAmountTitle = "Total amount"
	public let increaseInvestmentButtonTitle = "Increase investment"
	public let withdrawButtonTitle = "Withdraw"
	public var apy: String
	public var apyVolatilityType: AssetVolatilityType

	public var pageTitle: String {
		"\(assetName) investment"
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
		selectedAsset.formattedTokenAmountInDollor
	}

	public var investProtocolName: String {
		selectedAsset.assetProtocol.name
	}

	public var investProtocolImage: String {
		selectedAsset.protocolImage
	}

	public var investmentAmount: String {
		if selectedAsset.tokenInvestedAmountInDollar < 0.bigNumber {
			return "-" + selectedAsset.tokenInvestedAmountInDollar.priceFormat(of: selectedAsset.assetType, withRule: .standard)
		} else {
			return selectedAsset.tokenInvestedAmountInDollar.priceFormat(of: selectedAsset.assetType, withRule: .standard)
		}
	}

	public var earnedFee: String {
		if selectedAsset.earnedFee < 0.bigNumber {
			return "-" + (selectedAsset.earnedFee.priceFormat(of: selectedAsset.assetType, withRule: .standard))
		} else {
			return selectedAsset.earnedFee.priceFormat(of: selectedAsset.assetType, withRule: .standard)
		}
	}

	public var feeVolatilityType: AssetVolatilityType {
		.init(change24h: selectedAsset.earnedFee)
	}

	public var totalInvestmentAmount: String {
		selectedAsset.tokenTotalAmountInDollar.priceFormat(of: selectedAsset.assetType, withRule: .standard)
	}

	// MARK: Initializers

	init(selectedAsset: InvestAssetViewModel, apy: BigNumber) {
		self.selectedAsset = selectedAsset
		self.apyVolatilityType = .init(change24h: apy)
		self.apy = "%\(apy.percentFormat)"
	}
}
