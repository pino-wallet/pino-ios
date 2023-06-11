//
//  SelectAssetCellViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Foundation

class SelectAssetCellViewModel: SelectAssetCellVMProtocol {
	// MARK: - Public Properties

	var assetModel: AssetProtocol

	var assetName: String {
		assetModel.detail?.name ?? ""
	}

	var assetSymbol: String {
		assetModel.detail?.symbol ?? ""
	}

	var assetAmount: String {
		BigNumber(number: assetModel.amount, decimal: 6).description
	}

	var assetLogo: URL! {
		URL(string: assetModel.detail!.logo)
	}

	// MARK: - Initializers

	init(assetModel: AssetProtocol) {
		self.assetModel = assetModel
	}
}
