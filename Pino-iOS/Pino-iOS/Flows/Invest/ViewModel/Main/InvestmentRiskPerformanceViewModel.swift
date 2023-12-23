//
//  InvestmentRiskPerformanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import Foundation

struct InvestmentRiskPerformanceViewModel {
	// MARK: - Private Properties

	private let selectedAsset: InvestableAssetViewModel
	private let investableAsset: InvestableAsset

	// MARK: - Public Properties

	public let protocolTitle = "Protocol"
	public let investmentRiskTitle = "Benefits and risks"
	public let confirmButtonTitle = "Got it"

	public var risksInfo: [(titel: String, color: String)]? {
		investableAsset.riskInfo
	}

	public var assetImage: URL {
		selectedAsset.assetImage
	}

	public var assetName: String {
		selectedAsset.assetName
	}

	public var protocolImage: String {
		selectedAsset.assetProtocol.image
	}

	public var protocolName: String {
		selectedAsset.assetProtocol.name
	}

	public var protocolDescription: String? {
		investableAsset.riskDescription
	}

	public var investmentRisk: InvestmentRisk {
		selectedAsset.investmentRisk
	}

	public var investmentRiskName: String {
		investmentRisk.title
	}

	// MARK: - Initializers

	init(selectedAsset: InvestableAssetViewModel) {
		self.selectedAsset = selectedAsset
		self.investableAsset = InvestableAsset(
			assetId: selectedAsset.assetId,
			investProtocol: selectedAsset.assetProtocol
		)
	}
}
