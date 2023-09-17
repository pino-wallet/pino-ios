//
//  UserBorrowingAssetModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

#warning("this values are temporary and maybe should change")
struct UserBorrowingAssetModel {
	// MARK: - Public Properties

	public var userBorrowingModel: UserBorrowingToken

	public var tokenImage: URL {
		foundBorrowingTokenInManageAssetTokens.image
	}

	public var tokenSymbol: String {
		foundBorrowingTokenInManageAssetTokens.symbol
	}

	public var userBorrowingAmountInToken: BigNumber {
		BigNumber(number: userBorrowingModel.amount, decimal: foundBorrowingTokenInManageAssetTokens.decimal)
	}

	public var userBorrowingAmountInDollars: String {
		(foundBorrowingTokenInManageAssetTokens.price * userBorrowingAmountInToken).priceFormat
	}

	public var defaultBorrowingTokenModel: UserBorrowingToken {
		userBorrowingModel
	}

	// MARK: - Private Properties

	private var foundBorrowingTokenInManageAssetTokens: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userBorrowingModel.id }))!
	}
}
