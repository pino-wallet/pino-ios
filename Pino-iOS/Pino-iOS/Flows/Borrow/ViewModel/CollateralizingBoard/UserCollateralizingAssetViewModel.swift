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

	public var assetId: String {
		foundCollateralledToken.id
	}

	public var assetName: String {
		foundCollateralledToken.symbol
	}

	public var assetImage: URL {
		foundCollateralledToken.image
	}

	public var userCollateralizingInToken: String {
		userAmountInToken.sevenDigitFormat.tokenFormatting(token: foundCollateralledToken.symbol)
	}

	public var userCollateralizingInDollars: String {
		let userAmountInDollars = userAmountInToken * foundCollateralledToken.price
		return userAmountInDollars.priceFormat(of: foundCollateralledToken.assetType, withRule: .standard)
	}

	public var userCollaterlizingID: String {
		userCollateralizingAssetModel.id
	}

	// MARK: - Private Properties

	private var foundCollateralledToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userCollateralizingAssetModel.id }))!
	}

	private var userAmountInToken: BigNumber {
		BigNumber(number: userCollateralizingAssetModel.amount, decimal: foundCollateralledToken.decimal)
	}

	// MARK: - Initializers

	init(userCollateralizingAssetModel: UserBorrowingToken) {
		self.userCollateralizingAssetModel = userCollateralizingAssetModel
	}
}
