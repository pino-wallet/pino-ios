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

	public var assetAmount: BigNumber {
		BigNumber(number: assetModel.currentWorth, decimal: 2)
	}

	public var formattedAssetAmount: String {
		assetAmount.priceFormat
	}

	public var tokenAmount: BigNumber {
		BigNumber(number: assetModel.tokens.first!.amount, decimal: 2)
	}

	public var formattedTokenAmount: String {
		assetAmount.sevenDigitFormat.tokenFormatting(token: assetName)
	}

	public var assetVolatility: BigNumber {
		BigNumber(number: "0", decimal: 2)
	}

	public var formattedAssetVolatility: String {
		assetVolatility.priceFormat
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: assetVolatility)
	}

	public var apyAmount: String {
		assetModel.apyAmount
	}

	// MARK: - Initializers

	init(assetModel: InvestAssetModel) {
		self.assetModel = assetModel
	}
}
