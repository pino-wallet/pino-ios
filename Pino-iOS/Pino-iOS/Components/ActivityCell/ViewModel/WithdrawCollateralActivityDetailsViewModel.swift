//
//  WithdrawCollateralDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/12/23.
//

import Foundation

struct WithdrawCollateralActivityDetailsViewModel: ActivityDetailsProtocol {
    // MARK: - Internal Properties

    internal var activityModel: ActivityCollateralModel
    internal var globalAssetsList: [AssetViewModel]

    // MARK: - Private Properties

    private var responseSelectedToken: ActivityTokenModel {
        activityModel.detail.tokens[0]
    }

    private var token: AssetViewModel? {
        globalAssetsList.first(where: { $0.id.lowercased() == responseSelectedToken.tokenID.lowercased() })
    }

    // MARK: - Public Properties

    public var tokenAmount: BigNumber {
        BigNumber(number: responseSelectedToken.amount, decimal: token?.decimal ?? 0)
    }

    public var tokenSymbol: String {
        token?.symbol ?? ""
    }

    public var tokenImage: URL? {
        token?.image
    }

    public var activityProtocol: String {
        activityModel.detail.activityProtocol
    }
}
