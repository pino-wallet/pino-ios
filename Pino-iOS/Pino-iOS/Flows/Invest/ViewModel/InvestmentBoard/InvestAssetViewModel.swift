//
//  InvestAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Foundation

public struct InvestAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private let assetModel: InvestmentModel

	// MARK: - Public Properties

	public var listId: String {
		assetModel.listingID
	}

	public var investToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.id == assetModel.tokens.first!.tokenID })!
	}

	public var assetName: String {
		investToken.symbol
	}

	public var assetImage: URL {
		investToken.image
	}

	public var assetProtocol: InvestProtocolViewModel {
		InvestProtocolViewModel(type: assetModel.protocolName)
	}

	public var protocolImage: String {
		assetProtocol.image
	}

	public var investmentAmount: BigNumber {
		BigNumber(number: assetModel.currentWorth, decimal: 2)
	}

	public var formattedInvestmentAmount: String {
		investmentAmount.priceFormat
	}

	public var tokenAmount: BigNumber {
		BigNumber(number: assetModel.tokens.first!.amount, decimal: investToken.decimal)
	}

	public var tokenAmountInDollor: BigNumber {
		tokenAmount * investToken.price
	}

	public var formattedTokenAmount: String {
		tokenAmount.sevenDigitFormat.tokenFormatting(token: assetName)
	}

	public var formattedTokenAmountInDollor: String {
		tokenAmountInDollor.priceFormat
	}

	#warning("We don't have this data yet")
	public var assetVolatility: BigNumber {
		BigNumber(number: "0", decimal: 2)
	}

	public var formattedAssetVolatility: String {
		assetVolatility.priceFormat
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: assetVolatility)
	}

	// MARK: - Initializers

	init(assetModel: InvestmentModel) {
		self.assetModel = assetModel
	}
}
