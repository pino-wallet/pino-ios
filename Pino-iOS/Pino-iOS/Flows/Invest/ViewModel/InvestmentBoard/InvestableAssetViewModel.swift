//
//  InvestableAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import Foundation

public struct InvestableAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private let assetModel: InvestableAssetsModel

	// MARK: - Public Properties

	public var investToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.id == assetModel.tokens.first!.tokenId })!
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

	public var APYAmount: Int {
		assetModel.apy
	}

	public var formattedAPYAmount: String {
		"%\(APYAmount)"
	}

	public var volatilityType: AssetVolatilityType {
		.profit
	}

	public var investmentRisk: InvestmentRisk {
		InvestmentRisk(rawValue: assetModel.risk)!
	}

	// MARK: - Initializers

	init(assetModel: InvestableAssetsModel) {
		self.assetModel = assetModel
	}
}
