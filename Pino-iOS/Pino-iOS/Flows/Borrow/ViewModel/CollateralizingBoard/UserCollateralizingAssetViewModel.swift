//
//  UserCollateralizingAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

struct UserCollateralizingAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private var userCollateralizingAssetModel: UserBorrowingToken

	// MARK: - Public Properties

	public var assetName: String {
		foundTokenInManageAssetTokens.symbol
	}

	public var assetImage: URL {
		foundTokenInManageAssetTokens.image
	}

	public var userCollateralizingInToken: String {
		userAmountInToken.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var userCollateralizingInDollars: String {
		let userAmountInDollars = userAmountInToken * foundTokenInManageAssetTokens.price
		return userAmountInDollars.priceFormat
	}

	public var userCollaterlizingID: String {
		userCollateralizingAssetModel.id
	}

	// MARK: - Private Properties

	private var foundTokenInManageAssetTokens: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userCollateralizingAssetModel.id }))!
	}

	private var userAmountInToken: BigNumber {
		BigNumber(number: userCollateralizingAssetModel.amount, decimal: foundTokenInManageAssetTokens.decimal)
	}

	// MARK: - Initializers

	init(userCollateralizingAssetModel: UserBorrowingToken) {
		self.userCollateralizingAssetModel = userCollateralizingAssetModel
	}
}
