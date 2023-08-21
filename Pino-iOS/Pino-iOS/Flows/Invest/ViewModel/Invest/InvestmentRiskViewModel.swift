//
//  InvestmentRiskViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/21/23.
//

import Foundation

public enum InvestmentRisk: String {
	case high = "High"
	case medium = "Medium"
	case low = "Low"

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
