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
	public var totalAmount: BigNumber

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
		let amountPercentage = (assetVM.holdAmountInDollorNumber * BigNumber(number: 100, decimal: 0)) / totalAmount
		return "\(amountPercentage!.formattedAmountOf(type: .price))%"
	}

	public var progressBarValue: Float {
		Float(assetVM.holdAmountInDollorNumber.doubleValue / totalAmount.doubleValue)
	}

	// MARK: - Initializers

	init(assetVM: AssetViewModel!, totalAmount: BigNumber) {
		self.assetVM = assetVM
		self.totalAmount = totalAmount
	}
}
