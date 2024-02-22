//
//  WrapActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 2/21/24.
//

import Foundation

struct WrapActivityDetailsViewModel {
	// MARK: - Internal Properties

	internal var activityModel: ActivityWrapETHModel
	internal var fromToken: AssetViewModel
	internal var toToken: AssetViewModel

	// MARK: - Public Properties

	public var fromTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.amount, decimal: fromToken.decimal)
	}

	public var toTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.amount, decimal: toToken.decimal)
	}

	public var toTokenSymbol: String {
		toToken.symbol
	}

	public var fromTokenSymbol: String {
		fromToken.symbol
	}

	public var fromTokenImage: URL? {
		if fromToken.isVerified {
			return fromToken.image
		} else {
			return nil
		}
	}

	public var toTokenImage: URL? {
		if toToken.isVerified {
			return toToken.image
		} else {
			return nil
		}
	}
}
