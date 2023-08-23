//
//  InvestmentFilterItemViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation

public struct InvestmentFilterItemViewModel {
	// MARK: - Public Properties

	public var filterItem: FilterItem

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

	init(item: FilterItem, description: String?) {
		self.filterItem = item
		if let description {
			self.description = description
		} else {
			self.description = "All"
		}
	}

	// MARK: - Public Methods

	public mutating func updateDescription(_ description: String) {
		self.description = description
	}

	public enum FilterItem {
		case assets
		case investProtocol
		case risk
	}
}
