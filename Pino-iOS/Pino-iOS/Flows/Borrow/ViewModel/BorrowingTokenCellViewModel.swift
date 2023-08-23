//
//  File.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/23/23.
//

struct BorrowingTokenCellViewModel {
   // MARK: - Public Properties
    public var borrowinTokenModel: BorrowingTokenModel
    
    public var totalSharedBorrowingDivedPercentage: Double {
        return borrowinTokenModel.tokenSharedBorrowingPercentage / 100
    }
    
    public var prevTotalSharedBorrowingDivedPercentage: Double {
        return borrowinTokenModel.prevTokenSharedBorrowingPercentage / 100
    }
    
    public var tokenImage: String {
        return borrowinTokenModel.tokenImage
    }
    
}
