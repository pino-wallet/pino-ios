//
//  InvestViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import Foundation

struct InvestViewModel {
	// MARK: Public Properties

	public var assets: [InvestAssetViewModel]!
	public let investmentPerformamceTitle = "Investment performance"
	public let investmentPerformanceIcon = "Invest"
	public let totalInvestmentTitle = "Total investment value"
	public var totalInvestments: String {
		"$2463"
	}

	// MARK: Initializers

	init() {
		getAssets()
	}

	// MARK: - Private Methods

	private mutating func getAssets() {
		let assetsModel = [
			InvestAssetModel(assetName: "ETH", assetImage: "", assetAmount: "1100", assetVolatility: "40"),
			InvestAssetModel(assetName: "DAI", assetImage: "", assetAmount: "420", assetVolatility: "-23"),
			InvestAssetModel(assetName: "USDT", assetImage: "", assetAmount: "370", assetVolatility: "14"),
			InvestAssetModel(assetName: "SNT", assetImage: "", assetAmount: "240", assetVolatility: "18"),
			InvestAssetModel(assetName: "BNB", assetImage: "", assetAmount: "215", assetVolatility: "-31"),
			InvestAssetModel(assetName: "ENS", assetImage: "", assetAmount: "118", assetVolatility: "8"),
		]
		assets = assetsModel.compactMap { InvestAssetViewModel(assetModel: $0) }
	}
}
