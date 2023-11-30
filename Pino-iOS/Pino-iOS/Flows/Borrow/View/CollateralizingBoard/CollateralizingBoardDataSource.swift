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
	public var collateralizableAssets: [CollateralizableAssetViewModel]?

	// MARK: - Initializers

	init(
		userCollateralizingAssets: [UserCollateralizingAssetViewModel],
		collateralizableAssets: [CollateralizableAssetViewModel]?
	) {
		self.userCollateralizingAssets = userCollateralizingAssets
		self.collateralizableAssets = collateralizableAssets
	}

	// MARK: - Internal Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
			2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return userCollateralizingAssets.count
		case 1:
			return collateralizableAssets?.count ?? 4
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
			let assetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: UserCollateralizingAssetCell.cellReuseID,
				for: indexPath
			) as! UserCollateralizingAssetCell
			assetCell.userCollateralizingAssetVM = userCollateralizingAssets[indexPath.item]
			assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: userCollateralizingAssets.count)
			return assetCell
		case 1:
			let assetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: CollateralizableAssetCell.cellReuseID,
				for: indexPath
			) as! CollateralizableAssetCell
			assetCell.collateralizableAssetVM = collateralizableAssets?[indexPath.item]
			assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: collateralizableAssets?.count ?? 4)
			return assetCell
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
