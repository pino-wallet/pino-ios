//
//  BorrowActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/8/23.
//

import Foundation

struct BorrowActivityDetailsViewModel: ActivityDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityBorrowModel
	internal var globalAssetsList: [AssetViewModel]

	// MARK: - Private Properties

	private var token: AssetViewModel? {
		globalAssetsList.first(where: { $0.id.lowercased() == activityModel.detail.token.tokenID.lowercased() })
	}

	// MARK: - Public Properties

	public var tokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.token.amount, decimal: token?.decimal ?? 0)
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
