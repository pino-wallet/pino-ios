//
//  WithdrawActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/9/23.
//

import Foundation

struct WithdrawInvestmentActivityDetailsViewModel: ActivityCellDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityInvestmentModelProtocol
	internal var token: AssetViewModel

	// MARK: - Private Properties

	private var responseSelectedToken: ActivityTokenModel {
		activityModel.detail.tokens[0]
	}

	// MARK: - Public Properties

	public var tokenAmount: BigNumber {
		BigNumber(number: responseSelectedToken.amount, decimal: token.decimal)
	}

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
