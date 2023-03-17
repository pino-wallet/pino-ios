//
//  CoinPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

struct ShareOfAssetsViewModel {
	public var assetModel: AssetModel!
	public var randProgressValue = Int.random(in: 10 ... 90)
	public var assetName: String {
		assetModel.name
	}

	public var assetImage: String {
		assetModel.image
	}

	public var assetAmount: String {
		"$\(assetModel.amountInDollor)"
	}

	public var amountPercentage: String {
		"\(randProgressValue)%"
	}

	public var progressBarValue: Float {
		Float(randProgressValue) / 100
	}
}
