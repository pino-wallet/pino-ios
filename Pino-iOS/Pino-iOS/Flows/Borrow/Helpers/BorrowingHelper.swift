//
//  BorrowHelper.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/5/23.
//

import Foundation


struct BorrowingHelper {
    // MARK: - Public Methods
    public func calculateHealthScore(totalBorrowedAmount: BigNumber, totalBorrowableAmount: BigNumber) -> Double {
        let divedTotalBorrowAmount = totalBorrowedAmount / totalBorrowableAmount
        print("heh", totalBorrowedAmount, totalBorrowableAmount, divedTotalBorrowAmount)
        let plainHealhScore = 1.bigNumber - divedTotalBorrowAmount!
        return (plainHealhScore * 100.bigNumber).doubleValue
    }
}
