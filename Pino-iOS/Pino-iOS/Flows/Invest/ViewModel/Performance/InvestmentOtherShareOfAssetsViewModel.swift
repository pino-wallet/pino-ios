//
//  InvestmentOtherShareOfAssetsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation

struct InvestmentOtherShareOfAssetsViewModel: ShareOfAssetsProtocol {
	// MARK: - Public Properties

	public var assetsVM: [InvestAssetViewModel]
	public var assetName: String
	public var assetImage: URL?
	public var protocolImage: String?

	// MARK: - Internal Properties

	internal var holdAmount: BigNumber
	internal var totalAmount: BigNumber

	// MARK: - Initializers

	init(assetsVM: [InvestAssetViewModel], totalAmount: BigNumber) {
		self.assetsVM = assetsVM
		self.assetName = "Others"
		self.assetImage = nil
		self.protocolImage = nil
		self.holdAmount = assetsVM.compactMap { $0.assetAmount }.reduce(0.bigNumber, +)
		self.totalAmount = totalAmount
	}
}
