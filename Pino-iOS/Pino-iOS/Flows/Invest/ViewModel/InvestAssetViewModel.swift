//
//  InvestAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Foundation

public struct InvestAssetViewModel {
	// MARK: - Private Properties

	private let assetModel: InvestAssetModel

	// MARK: - Public Properties

	public var assetName: String {
		assetModel.assetName
	}

	public var assetImage: String {
		assetModel.assetImage
	}

	public var assetAmount: BigNumber {
		// Temporary
		BigNumber(number: assetModel.assetAmount, decimal: assetModel.decimal)
	}

	public var formattedAssetAmount: String {
		assetAmount.sevenDigitFormat.currencyFormatting
	}

	public var assetVolatility: BigNumber {
		// Temporary
		BigNumber(number: assetModel.assetVolatility, decimal: assetModel.decimal)
	}

	public var formattedAssetVolatility: String {
		assetVolatility.sevenDigitFormat.currencyFormatting
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: assetVolatility)
	}

	// MARK: - Initializers

	init(assetModel: InvestAssetModel) {
		self.assetModel = assetModel
	}
}
