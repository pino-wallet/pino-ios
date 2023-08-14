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
				assetAmount: "31000000000000",
				assetVolatility: "400000000000"
			),
			InvestAssetModel(
				assetName: "LINK",
				assetImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				assetAmount: "14200000000000",
				assetVolatility: "-230000000000"
			),
			InvestAssetModel(
				assetName: "AAVE",
				assetImage: "https://demo-cdn.pino.xyz/tokens/aave.png",
				assetAmount: "6700000000000",
				assetVolatility: "140000000000"
			),
			InvestAssetModel(
				assetName: "DAI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/dai.png",
				assetAmount: "1330000000000",
				assetVolatility: "180000000000"
			),
			InvestAssetModel(
				assetName: "USDT",
				assetImage: "https://demo-cdn.pino.xyz/tokens/tether.png",
				assetAmount: "456000000000",
				assetVolatility: "-310000000000"
			),
			InvestAssetModel(
				assetName: "UNI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/uniswap.png",
				assetAmount: "180000000000",
				assetVolatility: "80000000000"
			),
		]
		assets = assetsModel.compactMap { InvestAssetViewModel(assetModel: $0) }
	}
}
