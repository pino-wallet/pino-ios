//
//  InvestableAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import Foundation

public struct InvestableAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private let assetModel: InvestableAssetModel

	// MARK: - Public Properties

	public var assetName: String {
		assetModel.assetName
	}

	public var assetImage: URL {
		URL(string: assetModel.assetImage)!
	}

	public var assetProtocol: InvestProtocolViewModel {
		InvestProtocolViewModel(name: assetModel.protocolName)
	}

	public var protocolImage: String {
		assetProtocol.protocolInfo.image
	}

	public var APYAmount: BigNumber {
		BigNumber(number: assetModel.APYAmount, decimal: assetModel.decimal)
	}

	public var formattedAPYAmount: String {
		"%\(APYAmount.percentFormat)"
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: APYAmount)
	}

	// MARK: - Initializers

	init(assetModel: InvestableAssetModel) {
		self.assetModel = assetModel
	}
}
