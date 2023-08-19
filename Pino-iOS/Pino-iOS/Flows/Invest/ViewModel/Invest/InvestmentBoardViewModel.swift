//
//  InvestmentBoardViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import Foundation

struct InvestmentBoardViewModel {
	// MARK: - Public Properties

	public let userInvestmentsTitle = "My investments"
	public let investableAssetsTitle = "Investable assets"
	public var investableAssets = [InvestableAssetViewModel]()
	public var userInvestments = [InvestAssetViewModel]()

	// MARK: - Initializers

	init(userInvestments: [InvestAssetViewModel]) {
		self.userInvestments = userInvestments
		getInvestableAssets()
	}

	// MARK: - Private Methods

	private mutating func getInvestableAssets() {
		let investableAssetsModel = [
			InvestableAssetModel(
				assetName: "LINK",
				assetImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				protocolName: "Balancer",
				APYAmount: "30000000000"
			),
			InvestableAssetModel(
				assetName: "AAVE",
				assetImage: "https://demo-cdn.pino.xyz/tokens/aave.png",
				protocolName: "Balancer",
				APYAmount: "10000000000"
			),
			InvestableAssetModel(
				assetName: "DAI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/dai.png",
				protocolName: "Uniswap",
				APYAmount: "10000000000"
			),
			InvestableAssetModel(
				assetName: "USDT",
				assetImage: "https://demo-cdn.pino.xyz/tokens/tether.png",
				protocolName: "Uniswap",
				APYAmount: "40000000000"
			),
		]

		investableAssets = investableAssetsModel.compactMap { InvestableAssetViewModel(assetModel: $0) }
	}
}
