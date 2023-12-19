//
//  UserBorrowerAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

struct UserBorrowingAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private var userBorrowingTokenModel: UserBorrowingToken

	// MARK: - Public Properties

	public var assetId: String {
		foundBorrowedToken.id
	}

	public var assetName: String {
		foundBorrowedToken.symbol
	}

	public var assetImage: URL {
		foundBorrowedToken.image
	}

	public var userBorrowingInToken: String {
		userAmountInToken.sevenDigitFormat
			.tokenFormatting(token: foundBorrowedToken.symbol)
	}

	public var userBorrowingInDollars: String {
		let borrowingAmountinDollars = foundBorrowedToken.price * userAmountInToken
		return borrowingAmountinDollars.priceFormat
	}

	public var userBorrowingTokenID: String {
		userBorrowingTokenModel.id
	}

	// MARK: - Private Properties

	private var foundBorrowedToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userBorrowingTokenModel.id }))!
	}

	private var userAmountInToken: BigNumber {
		BigNumber(number: userBorrowingTokenModel.amount, decimal: foundBorrowedToken.decimal)
	}

	// MARK: - Initializers

	init(userBorrowingTokenModel: UserBorrowingToken) {
		self.userBorrowingTokenModel = userBorrowingTokenModel
	}
}
