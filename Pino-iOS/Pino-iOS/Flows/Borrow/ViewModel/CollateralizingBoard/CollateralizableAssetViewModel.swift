//
//  CollateralizableAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

struct CollateralizableAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private var collateralizableAssetModel: CollateralizableTokenDetailsModel

	// MARK: - Public Properties

	public var assetName: String {
		foundCollateralledToken.symbol
	}

	public var assetImage: URL {
		foundCollateralledToken.image
	}

	public var usrAmountInToken: String {
		foundCollateralledToken.holdAmount.sevenDigitFormat
			.tokenFormatting(token: foundCollateralledToken.symbol)
	}

	public var foundCollateralledToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == collateralizableAssetModel.tokenID }))!
	}

	// MARK: - Initializers

	init(collateralizableAssetModel: CollateralizableTokenDetailsModel) {
		self.collateralizableAssetModel = collateralizableAssetModel
	}
}
