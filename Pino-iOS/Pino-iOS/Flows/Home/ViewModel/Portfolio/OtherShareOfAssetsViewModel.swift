//
//  OtherShareOfAssetsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/1/23.
//

import Foundation

struct OtherShareOfAssetsViewModel: ShareOfAssetsProtocol {
	// MARK: - Public Properties

	public var assetsVM: [AssetViewModel]
	public var assetName: String
	public var assetImage: URL?

	// MARK: - Internal Properties

	internal var holdAmount: Double
	internal var totalAmount: Double

	// MARK: - Initializers

	init(assetsVM: [AssetViewModel], totalAmount: Double) {
		self.assetsVM = assetsVM
		self.assetName = "Others"
		self.assetImage = nil
		self.holdAmount = assetsVM.compactMap { $0.holdAmountInDollor.doubleValue }.reduce(0, +)
		self.totalAmount = totalAmount
	}
}
