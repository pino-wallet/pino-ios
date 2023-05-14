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

	internal var holdAmount: Double
	internal var totalAmount: Double

	// MARK: - Initializers

	init(assetVM: AssetViewModel, totalAmount: Double) {
		self.assetVM = assetVM
		self.assetName = assetVM.name
		self.assetImage = assetVM.image
		self.holdAmount = Double(assetVM.formattedHoldAmount)!
		self.totalAmount = totalAmount
	}
}
