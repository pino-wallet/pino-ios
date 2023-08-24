//
//  UserBorrowerAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

#warning("this values are temporary")
struct UserBorrowingAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private var userBorrowingAssetModel: UserBorrowingAssetModel

	// MARK: - Public Properties

	public var assetName: String {
		userBorrowingAssetModel.tokenSymbol
	}

	public var assetImage: URL {
		URL(string: userBorrowingAssetModel.tokenImage)!
	}

	public var userBorrowingInToken: String {
		"\(userBorrowingAssetModel.userBorrowingAmountInToken) \(userBorrowingAssetModel.tokenSymbol)"
	}

	public var userBorrowingInDollars: String {
		"$5000"
	}

	// MARK: - Initializers

	init(userBorrowingAssetModel: UserBorrowingAssetModel) {
		self.userBorrowingAssetModel = userBorrowingAssetModel
	}
}
