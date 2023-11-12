//
//  RepayActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/8/23.
//

import Foundation

struct RepayActivityDetailsViewModel: ActivityDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityRepayModel
	internal var globalAssetsList: [AssetViewModel]

	// MARK: - Private Properties

	private var token: AssetViewModel? {
		globalAssetsList.first(where: { $0.id.lowercased() == activityModel.detail.repaidToken.tokenID.lowercased() })
	}

	// MARK: - Public Properties

	public var tokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.repaidToken.amount, decimal: token?.decimal ?? 0)
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
