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
        foundTokenInManageAssetTokens.symbol
	}

	public var assetImage: URL {
        foundTokenInManageAssetTokens.image
	}

	public var usrAmountInToken: String {
        foundTokenInManageAssetTokens.holdAmount.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}
    
    // MARK: - Private Properties
    private var foundTokenInManageAssetTokens: AssetViewModel {
        (GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == collateralizableAssetModel.tokenID }))!
    }

	// MARK: - Initializers

	init(collateralizableAssetModel: CollateralizableTokenDetailsModel) {
		self.collateralizableAssetModel = collateralizableAssetModel
	}
}
