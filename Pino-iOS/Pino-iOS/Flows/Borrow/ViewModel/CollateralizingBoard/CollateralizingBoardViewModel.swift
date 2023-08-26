//
//  CollateralizingBoardViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

class CollateralizingBoardViewModel {
    // MARK: - Public Properties

    public let collateralsTitleText = "collaterals"
    public var userCollateralizingTokens: [UserCollateralizingAssetViewModel]
    public var collateralizableTokens: [CollateralizableAssetViewModel]

    // MARK: - Initializers

    init(userCollateralizingTokens: [UserCollateralizingAssetModel], collateralizableTokens: [CollateralizableAssetModel]) {
        self.userCollateralizingTokens = userCollateralizingTokens.compactMap {
            UserCollateralizingAssetViewModel(userCollateralizingAssetModel: $0)
        }
        self.collateralizableTokens = collateralizableTokens.compactMap {
            CollateralizableAssetViewModel(collateralizableAssetModel: $0)
        }
    }
}
