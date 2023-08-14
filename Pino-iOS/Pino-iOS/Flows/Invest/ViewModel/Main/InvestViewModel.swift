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
				assetName: "LINK",
				assetImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				protocolName: "Balancer",
				assetAmount: "31000000000000",
				assetVolatility: "-230000000000"
			),
			InvestAssetModel(
				assetName: "AAVE",
				assetImage: "https://demo-cdn.pino.xyz/tokens/aave.png",
				protocolName: "Balancer",
				assetAmount: "16700000000000",
				assetVolatility: "140000000000"
			),
			InvestAssetModel(
				assetName: "DAI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/dai.png",
				protocolName: "Uniswap",
				assetAmount: "1330000000000",
				assetVolatility: "180000000000"
			),
			InvestAssetModel(
				assetName: "USDT",
				assetImage: "https://demo-cdn.pino.xyz/tokens/tether.png",
				protocolName: "Uniswap",
				assetAmount: "456000000000",
				assetVolatility: "-310000000000"
			),
		]
		assets = assetsModel.compactMap { InvestAssetViewModel(assetModel: $0) }
	}
}
