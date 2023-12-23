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

enum InvestableAsset: String {
	case USDCAave
	case USDTAave
	case USDCCompound
	case USDTCompound
	case ETHLido
	case DAIMaker
	case none

	public var riskDescription: String? {
		switch self {
		case .USDCAave:
			"You deposit USDC into Aave’s lending pools and, in return, you receive fees from borrowers."
		case .USDTAave:
			"You deposit USDT into Aave’s lending pools and, in return, you receive fees from borrowers."
		case .USDCCompound:
			"You deposit USDC into Compound’s lending pools and, in return, you receive fees from borrowers."
		case .USDTCompound:
			"You deposit USDC into Compound’s lending pools and, in return, you receive fees from borrowers."
		case .ETHLido:
			"You deposit ETH in the Lido’s Ethereum nodes and in return, you receive fees from them."
		case .DAIMaker:
			"You deposit your DAI into Maker's DAI Savings Rate pool and, in return, you receive fees from borrowers."
		case .none:
			nil
		}
	}

	public var riskInfo: [(titel: String, color: String)]? {
		switch self {
		case .USDCAave:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .USDTAave:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .USDCCompound:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .USDTCompound:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .ETHLido:
			[
				("High yield", "Green Color"),
				("Variable principal", "Orange Color"),
				("Smart contract risk", "Orange Color"),
			]
		case .DAIMaker:
			[
				("Low yield", "Orange Color"),
				("Stable principal", "Green Color"),
				("Smart contract vulnerability", "Orange Color"),
			]
		case .none:
			nil
		}
	}

	public init(assetId: String, investProtocol: InvestProtocolViewModel) {
		switch investProtocol {
		case .compound:
			if assetId.lowercased() == "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48".lowercased() {
				self = .USDCCompound
			} else if assetId.lowercased() == "0xdAC17F958D2ee523a2206206994597C13D831ec7".lowercased() {
				self = .USDTCompound
			} else {
				self = .none
			}
		case .aave:
			if assetId.lowercased() == "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48".lowercased() {
				self = .USDCAave
			} else if assetId.lowercased() == "0xdAC17F958D2ee523a2206206994597C13D831ec7".lowercased() {
				self = .USDTAave
			} else {
				self = .none
			}
		case .maker:
			if assetId.lowercased() == "0x6B175474E89094C44Da98b954EedeAC495271d0F".lowercased() {
				self = .DAIMaker
			} else {
				self = .none
			}
		case .lido:
			if assetId.lowercased() == "0x0000000000000000000000000000000000000000".lowercased() {
				self = .ETHLido
			} else {
				self = .none
			}
		}
	}
}
