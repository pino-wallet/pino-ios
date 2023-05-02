//
//  ShareOfAssetProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/1/23.
//

import Foundation

protocol ShareOfAssetsProtocol {
	var holdAmount: Double { get set }
	var totalAmount: Double { get set }
	var assetAmount: String { get }
	var amountPercentage: String { get }
	var progressBarValue: Float { get }
	var assetName: String { get }
	var assetImage: URL? { get }
	var othersImage: String { get }
}

extension ShareOfAssetsProtocol {
	var assetAmount: String {
		"$\(holdAmount.roundToPlaces(2))"
	}

	var amountPercentage: String {
		let amountPercentage = (holdAmount / totalAmount) * 100
		if amountPercentage > 1 {
			return "\(amountPercentage.roundToPlaces(2))%"
		} else {
			return "Less than 1%"
		}
	}

	var progressBarValue: Float {
		Float(holdAmount / totalAmount)
	}

	var othersImage: String {
		"unverified_asset"
	}
}
