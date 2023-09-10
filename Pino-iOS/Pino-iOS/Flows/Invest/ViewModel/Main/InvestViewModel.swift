//
//  InvestViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import DGCharts
import Foundation

class InvestViewModel {
	// MARK: Public Properties

	public var assets: [InvestAssetViewModel]!
	public let investmentPerformamceTitle = "Investment performance"
	public let investmentPerformanceIcon = "Invest"
	public let totalInvestmentTitle = "Total investment value"
	public var totalInvestments: String {
		"$2463"
	}

	@Published
	public var chartDataEntries: [ChartDataEntry]?

	// MARK: Initializers

	init() {
		getAssets()
		getChartData()
	}

	// MARK: - Private Methods

	private func getAssets() {
		let assetsModel = [
			InvestAssetModel(
				assetName: "LINK",
				assetImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				protocolName: "balancer",
				assetAmount: "5067000000000",
				assetPrice: "61100000000",
				apyAmount: "3",
				earnedFee: "1000000000000",
				assetVolatility: "-230000000000"
			),
			InvestAssetModel(
				assetName: "AAVE",
				assetImage: "https://demo-cdn.pino.xyz/tokens/aave.png",
				protocolName: "balancer",
				assetAmount: "302500000000",
				assetPrice: "552000000000",
				apyAmount: "1",
				earnedFee: "800000000000",
				assetVolatility: "140000000000"
			),
			InvestAssetModel(
				assetName: "DAI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/dai.png",
				protocolName: "uniswap",
				assetAmount: "1330000000000",
				assetPrice: "11000000000",
				apyAmount: "1",
				earnedFee: "200000000000",
				assetVolatility: "180000000000"
			),
			InvestAssetModel(
				assetName: "USDT",
				assetImage: "https://demo-cdn.pino.xyz/tokens/tether.png",
				protocolName: "uniswap",
				assetAmount: "105800000000",
				assetPrice: "42800000000",
				apyAmount: "4",
				earnedFee: "80000000000",
				assetVolatility: "-310000000000"
			),
		]
		assets = assetsModel.compactMap { InvestAssetViewModel(assetModel: $0) }
	}

	private func getChartData() {
		chartDataEntries = [
			ChartDataEntry(x: 0, y: 0),
			ChartDataEntry(x: 1, y: 0.5),
			ChartDataEntry(x: 2, y: 0.2),
			ChartDataEntry(x: 3, y: 2),
			ChartDataEntry(x: 4, y: 1),
			ChartDataEntry(x: 5, y: 3),
			ChartDataEntry(x: 6, y: 1.3),
			ChartDataEntry(x: 7, y: 3),
			ChartDataEntry(x: 8, y: 1.5),
			ChartDataEntry(x: 9, y: 4),
			ChartDataEntry(x: 10, y: 0.5),
			ChartDataEntry(x: 11, y: 4),
		]
	}
}
