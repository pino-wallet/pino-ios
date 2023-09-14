//
//  BorrowingTokenModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/23/23.
//

import Foundation

struct BorrowingTokenModel {
	// MARK: - Public Properties

	public var tokenImage: URL
	#warning("this values should be BigNumber")
	public var tokenSharedBorrowingPercentage: BigNumber
	public var prevTokenSharedBorrowingPercentage: BigNumber
}
