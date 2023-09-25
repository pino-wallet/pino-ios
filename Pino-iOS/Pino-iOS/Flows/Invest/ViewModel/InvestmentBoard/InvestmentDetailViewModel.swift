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
	@Published
	public var apy: String?

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
		selectedAsset.formattedTokenAmountInDollor
	}

	public var investProtocolName: String {
		selectedAsset.assetProtocol.name
	}

	public var investProtocolImage: String {
		selectedAsset.protocolImage
	}

	public var investmentAmount: String {
		selectedAsset.formattedInvestmentAmount
	}

	public var earnedFee: String {
		selectedAsset.formattedAssetVolatility
	}

	public var totalInvestmentAmount: String {
		let totalAmount = selectedAsset.investmentAmount + selectedAsset.assetVolatility
		return totalAmount.priceFormat
	}

	public var investVolatilityType: AssetVolatilityType {
		selectedAsset.volatilityType
	}

	// MARK: Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.selectedAsset = selectedAsset
		getAPY()
	}

	public func getAPY() {
		investmentAPIClient.investmentListingInfo(listingId: selectedAsset.listId).sink { completed in
			switch completed {
			case .finished:
				print("Investment info received successfully")
			case let .failure(error):
				print("Error getting investment info:\(error)")
			}
		} receiveValue: { investmentInfo in
			self.apy = "%\(investmentInfo.first!.apy)"
		}.store(in: &cancellables)
	}
}
