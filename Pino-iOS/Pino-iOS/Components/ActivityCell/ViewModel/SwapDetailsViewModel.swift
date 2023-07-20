//
//  SwapDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

struct SwapDetailsViewModel: ActivityDetailsProtocol {
	// MARK: - Internal Properties

	internal var activityModel: ActivityModel
	internal var globalAssetsList: [AssetViewModel]

	// MARK: - Private Properties

	private var fromToken: AssetViewModel? {
		globalAssetsList.first(where: { $0.id == activityModel.detail?.fromToken?.tokenID })
	}

	private var toToken: AssetViewModel? {
		globalAssetsList.first(where: { $0.id == activityModel.detail?.toToken?.tokenID })
	}

	private var toTokenDecimal: Int {
		toToken?.decimal ?? 0
	}

	private var fromTokenDecimal: Int {
		fromToken?.decimal ?? 0
	}

	// MARK: - Public Properties

	public var fromTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail?.fromToken?.amount ?? "", decimal: fromToken?.decimal ?? 0)
	}

	public var toTokenAmount: BigNumber {
		BigNumber(number: activityModel.detail?.toToken?.amount ?? "", decimal: toToken?.decimal ?? 0)
	}

	public var toTokenSymbol: String {
		toToken?.symbol ?? ""
	}

	public var fromTokenSymbol: String {
		fromToken?.symbol ?? ""
	}
}
