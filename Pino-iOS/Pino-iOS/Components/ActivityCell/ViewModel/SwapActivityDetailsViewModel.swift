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

	private var toTokenDecimal: Int {
		toToken!.decimal
	}

	private var fromTokenDecimal: Int {
		fromToken!.decimal
	}

	// MARK: - Public Properties

	public var fromTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.fromToken.amount, decimal: fromTokenDecimal)
	}

	public var toTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail.toToken.amount, decimal: toTokenDecimal)
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