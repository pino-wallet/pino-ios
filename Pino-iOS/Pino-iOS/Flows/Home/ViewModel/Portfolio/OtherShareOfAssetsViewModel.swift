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

	internal var holdAmount: BigNumber
	internal var totalAmount: BigNumber
	internal var protocolImage: String?

	// MARK: - Initializers

	init(assetsVM: [AssetViewModel], totalAmount: BigNumber) {
		self.assetsVM = assetsVM
		self.assetName = "Others"
		self.assetImage = nil
		self.holdAmount = assetsVM.compactMap { $0.holdAmountInDollor }.reduce(0.bigNumber, +)
		self.totalAmount = totalAmount
	}
}
