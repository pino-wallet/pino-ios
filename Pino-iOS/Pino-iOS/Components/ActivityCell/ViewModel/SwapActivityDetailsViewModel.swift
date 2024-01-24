//
//  SwapDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

import Foundation

struct SwapActivityDetailsViewModel {
	// MARK: - Internal Properties

	internal var activityModel: ActivitySwapModel
	internal var fromToken: AssetViewModel
	internal var toToken: AssetViewModel

	// MARK: - Public Properties

	public var fromTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.fromToken.amount, decimal: fromToken.decimal)
	}

	public var toTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.toToken.amount, decimal: toToken.decimal)
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

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
