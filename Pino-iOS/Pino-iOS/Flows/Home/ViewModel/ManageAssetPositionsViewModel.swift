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
	public let positionsImage = "manage_asset_positions"
	public let positionsCount: Int
	public var isSelected: Bool {
		ManageAssetPositionsViewModel.positionsSelected
	}

	public static var positionsSelected: Bool {
		get {
			GlobalVariables.shared.currentAccount.isPositionEnabled
		}
		set {
			CoreDataManager().enableAccountPositions(newValue)
			GlobalVariables.shared.currentAccount.isPositionEnabled = newValue
		}
	}

	init(positions: [AssetViewModel]) {
		self.positionsCount = positions.count
	}
}
