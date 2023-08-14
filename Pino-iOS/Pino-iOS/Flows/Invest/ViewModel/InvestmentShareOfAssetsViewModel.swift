//
//  InvestmentShareOfAssetsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation

struct InvestmentShareOfAssetsViewModel: ShareOfAssetsProtocol {
	// MARK: - Public Properties

	public var assetName: String
	public var assetImage: URL?

	// MARK: - Internal Properties

	internal var holdAmount: BigNumber
	internal var totalAmount: BigNumber

	// MARK: - Initializers

	init(assetVM: InvestAssetViewModel, totalAmount: BigNumber) {
		self.assetName = assetVM.assetName
		self.assetImage = assetVM.assetImage
		self.holdAmount = assetVM.assetAmount
		self.totalAmount = totalAmount
	}
}
