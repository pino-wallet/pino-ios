//
//  UserCollateralizingAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

#warning("this values are temporary")
struct UserCollateralizingAssetViewModel: AssetsBoardProtocol {
    // MARK: - Private Properties

    private var userCollateralizingAssetModel: UserCollateralizingAssetModel

    // MARK: - Public Properties

    public var assetName: String {
        userCollateralizingAssetModel.tokenSymbol
    }

    public var assetImage: URL {
        URL(string: userCollateralizingAssetModel.tokenImage)!
    }

    public var userCollateralizingInToken: String {
        "\(userCollateralizingAssetModel.userCollateralizedAmountInToken) \(userCollateralizingAssetModel.tokenSymbol)"
    }

    public var userCollateralizingInDollars: String {
        "$5000"
    }

    // MARK: - Initializers

    init(userCollateralizingAssetModel: UserCollateralizingAssetModel) {
        self.userCollateralizingAssetModel = userCollateralizingAssetModel
    }
}
