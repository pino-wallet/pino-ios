//
//  BorrowingTokenModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/23/23.
//

struct BorrowingTokenModel {
	// MARK: - Public Properties

	public var tokenImage: String
    #warning("this values should be BigNumber")
	public var tokenSharedBorrowingPercentage: Double
	public var prevTokenSharedBorrowingPercentage: Double
}
