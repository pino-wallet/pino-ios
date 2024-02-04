//
//  BorrowHelper.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/5/23.
//

import Foundation

#warning("i should ask about this and double check with ali")
struct BorrowingHelper {
	// MARK: - Public Methods

	public func calculateHealthScore(
		totalBorrowedAmount: BigNumber,
		totalBorrowableAmountForHealthScore: BigNumber
	) -> BigNumber {
		if totalBorrowableAmountForHealthScore.isZero {
			return 0.bigNumber
		}
		let divedTotalBorrowAmount = totalBorrowedAmount / totalBorrowableAmountForHealthScore
		if totalBorrowedAmount.isZero || totalBorrowedAmount.number.sign == .minus {
			return 100.bigNumber
		}
		if divedTotalBorrowAmount?.number.sign == .minus {
			return 0.bigNumber
		}
		let plainHealhScore = 1.bigNumber - divedTotalBorrowAmount!
		return plainHealhScore * 100.bigNumber
	}
}
