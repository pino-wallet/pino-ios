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

	public var assetName: String {
        foundTokenInManageAssetTokens.symbol
	}

	public var assetImage: URL {
        foundTokenInManageAssetTokens.image
	}

	public var userBorrowingInToken: String {
		userAmountInToken.sevenDigitFormat
            .tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var userBorrowingInDollars: String {
        let borrowingAmountinDollars = foundTokenInManageAssetTokens.price * userAmountInToken
        return borrowingAmountinDollars.priceFormat
	}

	public var defaultUserBorrowingToken: UserBorrowingToken {
		userBorrowingTokenModel
	}
    
    // MARK: - Private Properties
    private var foundTokenInManageAssetTokens: AssetViewModel {
        (GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userBorrowingTokenModel.id }))!
    }
    
    private var userAmountInToken: BigNumber {
        BigNumber(number: userBorrowingTokenModel.amount, decimal: foundTokenInManageAssetTokens.decimal)
    }

	// MARK: - Initializers

	init(userBorrowingTokenModel: UserBorrowingToken) {
		self.userBorrowingTokenModel = userBorrowingTokenModel
	}
}
