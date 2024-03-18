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

	public let investToken: AssetViewModel

	public var investmentId: String {
		assetModel.id
	}

	public var listId: String {
		assetModel.listingID
	}

	public var assetId: String {
		investToken.id
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
		investmentAmount.priceFormat(of: assetType, withRule: .standard)
	}

	public var prevoiusInvestmentAmount: BigNumber {
		BigNumber(number: assetModel.lastDayWorth, decimal: 2)
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
		tokenAmountInDollor.priceFormat(of: assetType, withRule: .standard)
	}

	public var assetVolatility: BigNumber {
		investmentAmount - prevoiusInvestmentAmount
	}

	public var formattedAssetVolatility: String {
		assetVolatility.priceFormat(of: assetType, withRule: .standard)
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: assetVolatility)
	}

	public var investmentCapital: BigNumber {
		BigNumber(number: assetModel.capital, decimal: 2)
	}

	public var earnedFee: BigNumber {
		(tokenTotalAmount - tokenInvestedAmount) * investToken.price
	}

	public var tokenInvestedAmount: BigNumber {
		BigNumber(number: assetModel.tokens.first!.investedAmount, decimal: investToken.decimal)
	}

	public var tokenTotalAmount: BigNumber {
		BigNumber(number: assetModel.tokens.first!.totalAmount, decimal: investToken.decimal)
	}

	public var tokenInvestedAmountInDollar: BigNumber {
		tokenInvestedAmount * investToken.price
	}

	public var tokenTotalAmountInDollar: BigNumber {
		tokenTotalAmount * investToken.price
	}

	public var assetType: AssetType {
		investToken.assetType
	}

	// MARK: - Initializers

	init(assetModel: InvestmentModel, token: AssetViewModel) {
		self.assetModel = assetModel
		self.investToken = token
	}
}
