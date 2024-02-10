//
//  ShareOfAssetProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/1/23.
//

import Foundation

protocol ShareOfAssetsProtocol {
	var holdAmount: BigNumber { get set }
	var totalAmount: BigNumber { get set }
	var assetAmount: String { get }
	var amountPercentage: String { get }
	var progressBarValue: BigNumber? { get }
	var assetName: String { get }
	var assetImage: URL? { get }
	var protocolImage: String? { get }
	var othersImage: String { get }
}

extension ShareOfAssetsProtocol {
	var assetAmount: String {
		holdAmount.priceFormat
	}

	var amountPercentage: String {
		let amountPercentage = ((holdAmount * 100.bigNumber) / totalAmount)!
		if amountPercentage.isZero {
			return "0%"
		} else if amountPercentage > 1.bigNumber {
			return "\(amountPercentage.percentFormat)%"
		} else {
			return "<1%"
		}
	}

	var progressBarValue: BigNumber? {
		holdAmount / totalAmount
	}

	var othersImage: String {
		"unverified_asset"
	}
}
