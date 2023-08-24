//
//  BorrowableAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

struct BorrowableAssetViewModel: AssetsBoardProtocol {
    // MARK: - Private Properties
    private var borrowableAssetModel: BorrowableAssetModel
    
    // MARK: - Public Properties
    public var assetName: String {
        return borrowableAssetModel.tokenSymbol
    }
    public var assetImage: URL {
        return URL(string: borrowableAssetModel.tokenImage)!
    }
    
    public var APYAmount: BigNumber {
        BigNumber(number: borrowableAssetModel.tokenAPY, decimal: borrowableAssetModel.decimal)
    }

    public var formattedAPYAmount: String {
        "%\(APYAmount.percentFormat)"
    }

    public var volatilityType: AssetVolatilityType {
        AssetVolatilityType(change24h: APYAmount)
    }
    
    // MARK: - Initializers
    init(borrowableAssetModel: BorrowableAssetModel) {
        self.borrowableAssetModel = borrowableAssetModel
    }
}
