//
//  CollateralizingBoardDataSource.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation
import UIKit

class CollateralizingBoardDataSource: NSObject, UICollectionViewDataSource {
	// MARK: - private Properties

	// MARK: - Public Properties

	public var userCollateralizingAssets: [UserCollateralizingAssetViewModel]
	public var collateralizableAssets: [CollateralizableAssetViewModel]

	// MARK: - Initializers

	init(
		userCollateralizingAssets: [UserCollateralizingAssetViewModel],
		collateralizableAssets: [CollateralizableAssetViewModel]
	) {
		self.userCollateralizingAssets = userCollateralizingAssets
		self.collateralizableAssets = collateralizableAssets
	}

	// MARK: - Internal Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if userCollateralizingAssets.isEmpty {
			return 1
		} else {
			return 2
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return userCollateralizingAssets.count
		case 1:
			return collateralizableAssets.count
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		switch indexPath.section {
		case 0:
			let AssetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: UserCollateralizingAssetCell.cellReuseID,
				for: indexPath
			) as! UserCollateralizingAssetCell
			AssetCell.userCollateralizingAssetVM = userCollateralizingAssets[indexPath.item]
			AssetCell.setCellStyle(currentItem: indexPath.item, itemsCount: userCollateralizingAssets.count)
			return AssetCell
		case 1:
			let AssetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: CollateralizableAssetCell.cellReuseID,
				for: indexPath
			) as! CollateralizableAssetCell
			AssetCell.collateralizableAssetVM = collateralizableAssets[indexPath.item]
			AssetCell.setCellStyle(currentItem: indexPath.item, itemsCount: collateralizableAssets.count)
			return AssetCell
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: AssetsBoardHeaderView.viewReuseID,
			for: indexPath
		) as! AssetsBoardHeaderView
		switch indexPath.section {
		case 0:
			headerView.title = "Your collateralized assets"
			headerView.hasFilter = false
		case 1:
			headerView.title = "Collateralizable assets"
			headerView.hasFilter = false
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return headerView
	}
}
