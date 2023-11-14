//
//  RepayActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/8/23.
//

import Foundation

struct RepayActivityDetailsViewModel: ActivityCellDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityRepayModel
	internal var token: AssetViewModel

	// MARK: - Public Properties

	public var tokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.repaidToken.amount, decimal: token.decimal)
	}

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
