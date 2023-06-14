//
//  SelectAssetCellViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Foundation

struct SelectAssetCellViewModel: SelectAssetCellVMProtocol {
	// MARK: - Public Properties

	var assetModel: AssetProtocol

	var assetName: String {
		assetModel.detail!.name
	}

	var assetSymbol: String {
		assetModel.detail!.symbol
	}

	var assetAmount: String {
        BigNumber(number: assetModel.amount, decimal: assetModel.detail!.decimals).formattedAmountOf(type: .hold)
	}

	var assetLogo: URL! {
		URL(string: assetModel.detail!.logo)
	}

	// MARK: - Initializers

	init(assetModel: AssetProtocol) {
		self.assetModel = assetModel
	}
}
