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
			InvestAssetModel(
				assetName: "ETH",
				assetImage: "https://demo-cdn.pino.xyz/tokens/eth.png",
				assetAmount: "1100",
				assetVolatility: "40"
			),
			InvestAssetModel(
				assetName: "LINK",
				assetImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				assetAmount: "420",
				assetVolatility: "-23"
			),
			InvestAssetModel(
				assetName: "AAVE",
				assetImage: "https://demo-cdn.pino.xyz/tokens/aave.png",
				assetAmount: "370",
				assetVolatility: "14"
			),
			InvestAssetModel(
				assetName: "DAI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/dai.png",
				assetAmount: "240",
				assetVolatility: "18"
			),
			InvestAssetModel(
				assetName: "USDT",
				assetImage: "https://demo-cdn.pino.xyz/tokens/tether.png",
				assetAmount: "215",
				assetVolatility: "-31"
			),
			InvestAssetModel(
				assetName: "UNI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/uniswap.png",
				assetAmount: "118",
				assetVolatility: "8"
			),
		]
		assets = assetsModel.compactMap { InvestAssetViewModel(assetModel: $0) }
	}
}
