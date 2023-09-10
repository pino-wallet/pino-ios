//
//  InvestmentDetailViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/10/23.
//

import Foundation

struct InvestmentDetailViewModel {
	// MARK: - Private Properties

	private let selectedAsset: InvestAssetViewModel

	// MARK: - Public Properties

	public var pageTitle: String {
		"\(assetName) investment details"
	}

	public var assetName: String {
		selectedAsset.assetName
	}

	public var assetImage: URL {
		selectedAsset.assetImage
	}

	public var assetAmount: String {
		selectedAsset.formattedTokenAmount
	}

	public var assetAmountInDollar: String {
		selectedAsset.formattedAssetAmount
	}

	public var investProtocolName: String {
		selectedAsset.assetProtocol.name
	}

	public var investProtocolImage: String {
		selectedAsset.protocolImage
	}

	public var apyAmount: String {
		"%\(selectedAsset.apyAmount)"
	}

	public var investmentAmount: String {
		selectedAsset.formattedAssetAmount
	}

	public var earnedFee: String {
		selectedAsset.formattedEarnedFee
	}

	public var totalInvestmentAmount: String {
		selectedAsset.formattedTotalInvestmentAmount
	}

	// MARK: Initializers

	init(selectedAsset: InvestAssetViewModel) {
		self.selectedAsset = selectedAsset
	}
}
