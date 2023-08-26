//
//  CollateralizableAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

struct CollateralizableAssetViewModel: AssetsBoardProtocol {
    // MARK: - Private Properties

    private var collateralizableAssetModel: CollateralizableAssetModel

    // MARK: - Public Properties

    public var assetName: String {
        collateralizableAssetModel.tokenSymbol
    }

    public var assetImage: URL {
        URL(string: collateralizableAssetModel.tokenImage)!
    }

    public var usrAmountInToken: String {
        return "\(collateralizableAssetModel.userAmountInToken) \(collateralizableAssetModel.tokenSymbol)"
    }

    // MARK: - Initializers

    init(collateralizableAssetModel: CollateralizableAssetModel) {
        self.collateralizableAssetModel = collateralizableAssetModel
    }
}
