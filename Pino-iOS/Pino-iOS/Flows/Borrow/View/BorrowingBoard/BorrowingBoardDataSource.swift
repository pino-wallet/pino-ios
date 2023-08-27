//
//  BorrowingBoardDataSource.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation
import UIKit

class BorrowingBoardDataSource: NSObject, UICollectionViewDataSource {
	// MARK: - private Properties

	// MARK: - Public Properties

	public var userBorrowingAssets: [UserBorrowingAssetViewModel]
	public var borrowableAssets: [BorrowableAssetViewModel]

	// MARK: - Initializers

	init(
		userBorrowingAssets: [UserBorrowingAssetViewModel],
		borrowableAssets: [BorrowableAssetViewModel]
	) {
		self.userBorrowingAssets = userBorrowingAssets
		self.borrowableAssets = borrowableAssets
	}

	// MARK: - Internal Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return userBorrowingAssets.count
		case 1:
			return borrowableAssets.count
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
				withReuseIdentifier: UserBorrowingAssetCell.cellReuseID,
				for: indexPath
			) as! UserBorrowingAssetCell
			assetCell.userBorrowingAssetVM = userBorrowingAssets[indexPath.item]
			assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: userBorrowingAssets.count)
			return assetCell
		case 1:
			let assetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: BorrowableAssetCell.cellReuseID,
				for: indexPath
			) as! BorrowableAssetCell
			assetCell.borrowableAssetVM = borrowableAssets[indexPath.item]
			assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: borrowableAssets.count)
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
			headerView.title = "Your borrowed assets"
			headerView.hasFilter = false
		case 1:
			headerView.title = "Borrowable assets"
			headerView.hasFilter = false
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return headerView
	}
}
