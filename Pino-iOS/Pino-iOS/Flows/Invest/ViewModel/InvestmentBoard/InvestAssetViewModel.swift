//
//  InvestAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Foundation

public struct InvestAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private let assetModel: InvestAssetModel

	// MARK: - Public Properties

	public var assetName: String {
		assetModel.assetName
	}

	public var assetImage: URL {
		URL(string: assetModel.assetImage)!
	}

	public var assetProtocol: InvestProtocolViewModel {
		InvestProtocolViewModel(type: assetModel.protocolName)
	}

	public var protocolImage: String {
		assetProtocol.image
	}

	public var assetAmount: BigNumber {
		BigNumber(number: assetModel.assetAmount, decimal: assetModel.decimal)
			* BigNumber(number: assetModel.assetPrice, decimal: assetModel.decimal)
	}

	public var formattedAssetAmount: String {
		assetAmount.priceFormat
	}

	public var tokenAmount: BigNumber {
		BigNumber(number: assetModel.assetAmount, decimal: assetModel.decimal)
	}

	public var formattedTokenAmount: String {
		assetAmount.sevenDigitFormat.tokenFormatting(token: assetName)
	}

	public var assetVolatility: BigNumber {
		BigNumber(number: assetModel.assetVolatility, decimal: assetModel.decimal)
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
