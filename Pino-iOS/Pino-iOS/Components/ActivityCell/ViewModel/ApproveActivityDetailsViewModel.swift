//
//  ApproveActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/12/23.
//

import Foundation

struct ApproveActivityDetailsViewModel {
	// MARK: - Internal Properties

	internal var activityModel: ActivityApproveModel
    internal var token: AssetViewModel

	// MARK: - Public Properties

	public var tokenSymbol: String {
		token.symbol
	}

	public var tokenImage: URL? {
		token.image
	}
}
