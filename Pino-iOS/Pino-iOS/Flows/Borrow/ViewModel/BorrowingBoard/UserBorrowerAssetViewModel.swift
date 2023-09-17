//
//  UserBorrowerAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

struct UserBorrowingAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private var userBorrowingAssetModel: UserBorrowingAssetModel

	// MARK: - Public Properties

	public var assetName: String {
		userBorrowingAssetModel.tokenSymbol
	}

	public var assetImage: URL {
        userBorrowingAssetModel.tokenImage
	}

	public var userBorrowingInToken: String {
        userBorrowingAssetModel.userBorrowingAmountInToken.sevenDigitFormat.tokenFormatting(token: userBorrowingAssetModel.tokenSymbol)
	}

	public var userBorrowingInDollars: String {
        userBorrowingAssetModel.userBorrowingAmountInDollars
	}
    
    public var defaultUserBorrowingToken: UserBorrowingToken {
        userBorrowingAssetModel.defaultBorrowingTokenModel
    }

	// MARK: - Initializers

	init(userBorrowingAssetModel: UserBorrowingAssetModel) {
		self.userBorrowingAssetModel = userBorrowingAssetModel
	}
}
