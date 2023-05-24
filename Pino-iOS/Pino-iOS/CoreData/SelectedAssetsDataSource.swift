//
//  SelectedAssetsDataSource.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

import Foundation

struct SelectedAssetsDataSource {
	// MARK: - Private Properties

	private var selectedAssets = [SelectedAsset]()

	// MARK: - Public Methods

	public func getAll() -> [SelectedAsset] {
		selectedAssets
	}

	public func get(byId id: String) -> SelectedAsset? {
		selectedAssets.first(where: { $0.id == id })
	}

	public mutating func save(_ asset: SelectedAsset) {
		if let index = selectedAssets.firstIndex(where: { $0.id == asset.id }) {
			selectedAssets[index] = asset
		} else {
			selectedAssets.append(asset)
		}
	}

	public mutating func delete(_ asset: SelectedAsset) {
		selectedAssets.removeAll(where: { $0.id == asset.id })
	}

	public func filter(_ predicate: (SelectedAsset) -> Bool) -> [SelectedAsset] {
		selectedAssets.filter(predicate)
	}

	public func sort(by sorter: (SelectedAsset, SelectedAsset) -> Bool) -> [SelectedAsset] {
		selectedAssets.sorted(by: sorter)
	}
}
