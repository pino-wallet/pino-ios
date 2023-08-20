//
//  InvestmentBoardFilterViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation

struct InvestmentBoardFilterViewModel {
	// MARK: - Public Properties

	public var filters: [InvestmentFilterItemViewModel] = [.assets, .investProtocol, .risk]

	// MARK: - Initializers

	init() {}
}

public struct InvestmentFilterItemViewModel {
	// MARK: - Private Properties

	private var filterItem: FilterItem

	// MARK: - Public Properties

	public var title: String {
		switch filterItem {
		case .assets:
			return "Asset"
		case .investProtocol:
			return "Protocol"
		case .risk:
			return "Risk"
		}
	}

	public var description: String

	// MARK: - Initializers

	init(item: FilterItem, description: String) {
		self.filterItem = item
		self.description = description
	}

	public enum FilterItem {
		case assets
		case investProtocol
		case risk
	}
}

extension InvestmentFilterItemViewModel {
	public static let assets = InvestmentFilterItemViewModel(item: .assets, description: "All")
	public static let investProtocol = InvestmentFilterItemViewModel(item: .investProtocol, description: "Uniswap")
	public static let risk = InvestmentFilterItemViewModel(item: .risk, description: "High risk")
}
