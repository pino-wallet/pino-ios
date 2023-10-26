//
//  SwapDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

import Foundation

struct SwapActivityDetailsViewModel: ActivityDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivitySwapModel
	internal var globalAssetsList: [AssetViewModel]

	// MARK: - Private Properties

	private var fromToken: AssetViewModel? {
		globalAssetsList.first(where: { $0.id.lowercased() == activityModel.detail.fromToken.tokenID.lowercased() })
	}

	private var toToken: AssetViewModel? {
		globalAssetsList.first(where: { $0.id.lowercased() == activityModel.detail.toToken.tokenID.lowercased() })
	}

	// MARK: - Public Properties

	public var fromTokenAmount: BigNumber {
		BigNumber(numberWithDecimal: activityModel.detail.fromToken.amount)
	}

	public var toTokenAmount: BigNumber {
		BigNumber(numberWithDecimal: activityModel.detail.toToken.amount)
	}

	public var toTokenSymbol: String {
		toToken!.symbol
	}

	public var fromTokenSymbol: String {
		fromToken!.symbol
	}

	public var fromTokenImage: URL? {
		fromToken?.image
	}

	public var toTokenImage: URL? {
		toToken?.image
	}

	public var activityProtocol: String {
		activityModel.detail.activityProtocol
	}
}
