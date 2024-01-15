//
//  ManageAssetPositionsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/15/24.
//

import Foundation

public struct ManageAssetPositionsViewModel {
	// MARK: - Public Properties

	public let positionsTitle = "Positions"
	public let positionsImage = ""
	public let positionsCount: Int
	public let positionsUserDefaultKey = "isPositionsSelected"
	public var isSelected: Bool {
		UserDefaults.standard.bool(forKey: positionsUserDefaultKey)
	}

	init(positions: [AssetViewModel]) {
		self.positionsCount = positions.count
	}

	// MARK: - Public Methods

	public func toggleIsSelected(_ isSelected: Bool) {
		UserDefaults.standard.set(isSelected, forKey: positionsUserDefaultKey)
	}
}
