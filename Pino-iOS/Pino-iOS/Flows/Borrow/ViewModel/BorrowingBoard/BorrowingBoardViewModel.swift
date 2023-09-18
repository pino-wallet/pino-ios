//
//  BorrowingBoardViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

struct BorrowingBoardViewModel {
	// MARK: - Public Properties

	public let loansTitleText = "loans"
	public var userBorrowingTokens: [UserBorrowingAssetViewModel]
	public var borrowableTokens: [BorrowableAssetViewModel]

	// MARK: - Initializers

	init(userBorrowingTokens: [UserBorrowingToken], borrowableTokens: [BorrowableAssetModel]) {
		self.userBorrowingTokens = userBorrowingTokens.compactMap {
			UserBorrowingAssetViewModel(userBorrowingTokenModel: $0)
		}
		self.borrowableTokens = borrowableTokens.compactMap {
			BorrowableAssetViewModel(borrowableAssetModel: $0)
		}
	}
}
