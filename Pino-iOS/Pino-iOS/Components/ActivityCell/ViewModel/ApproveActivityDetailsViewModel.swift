//
//  ApproveActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/12/23.
//

import Foundation

struct ApproveActivityDetailsViewModel: ActivityDetailsProtocol {
    // MARK: - Internal Properties

    internal var activityModel: ActivityApproveModel
    internal var globalAssetsList: [AssetViewModel]

    // MARK: - Private Properties

    private var token: AssetViewModel? {
        var approveToken = globalAssetsList.first(where: { $0.id.lowercased() == activityModel.detail.tokenID.lowercased() })
        if let foundApprovetoken = approveToken, foundApprovetoken.isEth {
            approveToken = globalAssetsList.first(where: { $0.isWEth })
        }
        return approveToken
    }

    // MARK: - Public Properties

    public var tokenSymbol: String {
        token?.symbol ?? ""
    }

    public var tokenImage: URL? {
        token?.image
    }
}
