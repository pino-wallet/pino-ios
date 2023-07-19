//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Foundation

struct ShareOfAssetsViewModel: ShareOfAssetsProtocol {
	// MARK: - Public Properties

	public var assetVM: AssetViewModel
	public var assetName: String
	public var assetImage: URL?

	// MARK: - Internal Properties

	internal var holdAmount: BigNumber
	internal var totalAmount: BigNumber

	// MARK: - Initializers

	init(assetVM: AssetViewModel, totalAmount: BigNumber) {
		self.assetVM = assetVM
		self.assetName = assetVM.name
		self.assetImage = assetVM.image
		self.holdAmount = assetVM.holdAmountInDollor
		self.totalAmount = totalAmount
	}
}
