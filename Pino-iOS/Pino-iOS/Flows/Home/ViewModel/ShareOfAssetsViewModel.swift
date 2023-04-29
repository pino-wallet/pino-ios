//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import Foundation

struct ShareOfAssetsViewModel {
	// MARK: - Public Properties

	public var assetVM: AssetViewModel!
	public var totalAmount: Double

	public var assetName: String {
		assetVM.name
	}

	public var assetImage: URL {
		assetVM.image
	}

	public var assetAmount: String {
		"$\(assetVM.holdAmountInDollar)"
	}

	public var amountPercentage: String {
		let amountPercentage = (Double(assetVM.holdAmountInDollar)! / totalAmount) * 100
		return "\(round(amountPercentage * 100) / 100)%"
	}

	public var progressBarValue: Float {
		Float(Double(assetVM.holdAmountInDollar)! / totalAmount)
	}

	// MARK: - Initializers

	init(assetVM: AssetViewModel!, totalAmount: Double) {
		self.assetVM = assetVM
		self.totalAmount = totalAmount
	}
}
