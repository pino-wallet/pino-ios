//
//  InvestmentBoardViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import Foundation

class InvestmentBoardViewModel: InvestFilterDelegate {
	// MARK: - Public Properties

	public let userInvestmentsTitle = "My investments"
	public let investableAssetsTitle = "Investable assets"
	public var userInvestments = [InvestAssetViewModel]()
	public var investableAssets = [InvestableAssetViewModel]()
	@Published
	public var filteresAssets: [InvestableAssetViewModel]?

	public var assetFilter: AssetViewModel?
	public var protocolFilter: InvestProtocolViewModel?
	public var riskFilter: InvestmentRisk?

	// MARK: - Initializers

	init(userInvestments: [InvestAssetViewModel]) {
		self.userInvestments = userInvestments
		getInvestableAssets()
	}

	// MARK: - Private Methods

	private func getInvestableAssets() {
		let investableAssetsModel = [
			InvestableAssetModel(
				assetName: "LINK",
				assetImage: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				protocolName: "Balancer",
				APYAmount: "30000000000",
				investmentRisk: "High"
			),
			InvestableAssetModel(
				assetName: "AAVE",
				assetImage: "https://demo-cdn.pino.xyz/tokens/aave.png",
				protocolName: "Balancer",
				APYAmount: "10000000000",
				investmentRisk: "Medium"
			),
			InvestableAssetModel(
				assetName: "DAI",
				assetImage: "https://demo-cdn.pino.xyz/tokens/dai.png",
				protocolName: "Uniswap",
				APYAmount: "10000000000",
				investmentRisk: "Low"
			),
			InvestableAssetModel(
				assetName: "USDT",
				assetImage: "https://demo-cdn.pino.xyz/tokens/tether.png",
				protocolName: "Uniswap",
				APYAmount: "40000000000",
				investmentRisk: "High"
			),
		]

		investableAssets = investableAssetsModel.compactMap { InvestableAssetViewModel(assetModel: $0) }
	}

	// MARK: - Internal Methods

	internal func filterUpdated(
		assetFilter: AssetViewModel?,
		protocolFilter: InvestProtocolViewModel?,
		riskFilter: InvestmentRisk?
	) {
		self.assetFilter = assetFilter
		self.protocolFilter = protocolFilter
		self.riskFilter = riskFilter

		var filteringAssets = investableAssets
		if let assetFilter {
			filteringAssets = filteringAssets.filter { $0.assetName == assetFilter.symbol }
		}
		if let protocolFilter {
			filteringAssets = filteringAssets.filter { $0.assetProtocol.type == protocolFilter.type }
		}
		if let riskFilter {
			filteringAssets = filteringAssets.filter { $0.investmentRisk == riskFilter }
		}

		filteresAssets = filteringAssets
	}
}
