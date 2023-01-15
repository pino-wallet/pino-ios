//
//  ManageAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

public struct ManageAssetViewModel {
	// MARK: - Public Properties

	public var assetModel: AssetModel!

	public var image: String {
		assetModel.image
	}

	public var name: String {
		assetModel.name
	}

	public var amount: String {
		(assetModel.amount ?? "0.0") + assetModel.codeName
	}

	public var isSelected: Bool {
		assetModel.isSelected
	}

	// MARK: - Public Methods

	public mutating func toggleIsSelected() {
		assetModel.toggleIsSelected()
	}
}
