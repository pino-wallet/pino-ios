//
//  File.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/23/23.
//

struct BorrowingTokenCellViewModel {
	// MARK: - Public Properties

	public var borrowinTokenModel: BorrowingTokenModel

	public var totalSharedBorrowingDividedPercentage: Double {
		borrowinTokenModel.tokenSharedBorrowingPercentage / 100
	}

	public var prevTotalSharedBorrowingDividedPercentage: Double {
		borrowinTokenModel.prevTokenSharedBorrowingPercentage / 100
	}

	public var tokenImage: String {
		borrowinTokenModel.tokenImage
	}
}
