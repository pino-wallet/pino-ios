//
//  File.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/23/23.
//

import Foundation

struct BorrowingTokenCellViewModel {
	// MARK: - Public Properties

	public var borrowinTokenModel: BorrowingTokenModel?

	public var totalSharedBorrowingDividedPercentage: Double? {
		guard let borrowinTokenModel else {
			return nil
		}
		let bigNumberTotalSharedBorrowingPercentage = borrowinTokenModel.tokenSharedBorrowingPercentage / 100.bigNumber
		return Double(bigNumberTotalSharedBorrowingPercentage?.sevenDigitFormat ?? "0")
	}

	public var prevTotalSharedBorrowingDividedPercentage: Double? {
		guard let borrowinTokenModel else {
			return nil
		}
		let prevBigNumberTotalSharedBorrowingPercentage = borrowinTokenModel.prevTokenSharedBorrowingPercentage / 100
			.bigNumber
		return Double(prevBigNumberTotalSharedBorrowingPercentage?.sevenDigitFormat ?? "0")
	}

	public var tokenImage: URL? {
		borrowinTokenModel?.tokenImage
	}
}
