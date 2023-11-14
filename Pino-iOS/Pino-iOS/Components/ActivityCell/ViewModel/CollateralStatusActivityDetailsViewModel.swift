//
//  CollateralStatusActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/12/23.
//

import Foundation

struct CollateralStatusActivityDetailsViewModel {
	// MARK: - Internal Properties

	internal var activityModel: ActivityCollateralModel
    internal var token: AssetViewModel

	// MARK: - Private Properties

	private var responseSelectedToken: ActivityTokenModel {
		activityModel.detail.tokens[0]
	}

	// MARK: - Public Properties

	public var tokenSymbol: String {
		token.symbol
	}

	public var tokenImage: URL? {
		token.image
	}

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
