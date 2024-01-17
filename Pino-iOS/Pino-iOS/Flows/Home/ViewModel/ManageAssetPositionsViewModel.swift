//
//  ManageAssetPositionsViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/15/24.
//

import Foundation

public struct ManageAssetPositionsViewModel {
	// MARK: - Private Properties

	private static let positionsUserDefaultKey = "isPositionsSelected"

	// MARK: - Public Properties

	public let positionsTitle = "Positions"
	public let positionsImage = "manage_asset_positions"
	public let positionsCount: Int
	public var isSelected: Bool {
		ManageAssetPositionsViewModel.positionsSelected
	}

	public static var positionsSelected: Bool {
		get {
			UserDefaults.standard.bool(forKey: ManageAssetPositionsViewModel.positionsUserDefaultKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: ManageAssetPositionsViewModel.positionsUserDefaultKey)
		}
	}

	init(positions: [AssetViewModel]) {
		self.positionsCount = positions.count
	}
}
