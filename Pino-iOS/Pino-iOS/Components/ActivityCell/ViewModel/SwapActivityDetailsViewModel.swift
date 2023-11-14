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
		fromToken.image
	}

	public var toTokenImage: URL? {
		toToken.image
	}

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
