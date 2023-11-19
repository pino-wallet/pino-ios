//
//  CollateralStatusActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/12/23.
//

import Foundation

struct CollateralStatusActivityDetailsViewModel: ActivityCellDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityCollateralModel
	internal var token: AssetViewModel

	// MARK: - Private Properties

	private var responseSelectedToken: ActivityTokenModel {
		activityModel.detail.tokens[0]
	}

	// MARK: - Public Properties

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
