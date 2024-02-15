//
//  InvestmentRiskViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/21/23.
//

import Foundation

public enum InvestmentRisk: String {
	// MARK: - Types

	case high
	case medium
	case low

	// MARK: - Public Properties

	public var title: String {
		switch self {
		case .high:
			return "High risk"
		case .medium:
			return "Medium risk"
		case .low:
			return "Low risk"
		}
	}

	public var description: String {
		switch self {
		case .high:
			return "High earn potential, high principal value volatility."
		case .medium:
			return "Medium earn potential, medium principal value volatility."
		case .low:
			return "Low earn potential, Low principal value volatility."
		}
	}
}

struct InvestableAsset {
	// MARK: - Cases

	private var assetName: String
	private var selectedProtocol: InvestProtocolViewModel

	// MARK: - Public Properties

	public var riskDescription: String? {
		switch selectedProtocol {
		case .aave:
			"You deposit \(assetName) into Aave’s lending pools and, in return, you receive fees from borrowers."
		case .compound:
			"You deposit \(assetName) into Compound’s lending pools and, in return, you receive fees from borrowers."
		case .lido:
			"You deposit \(assetName) in the Lido’s Ethereum nodes and in return, you receive fees from them."
		case .maker:
			"You deposit your \(assetName) into Maker's DAI Savings Rate pool and, in return, you receive fees from borrowers."
		}
	}

	public var riskInfo: [(titel: String, color: String)]? {
		switch selectedProtocol {
		case .aave:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .compound:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .lido:
			[
				("High yield", "Green Color"),
				("Variable principal", "Orange Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .maker:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract vulnerability", "Orange Color"),
			]
		}
	}

	// MARK: - Public Initializers

	public init(investableAsset: InvestableAssetViewModel, investProtocol: InvestProtocolViewModel) {
		self.assetName = investableAsset.assetName
		self.selectedProtocol = investProtocol
	}
}
