//
//  InvestmentBoardDataSource.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import UIKit

class InvestmentBoardDataSource: NSObject, UICollectionViewDataSource {
	// MARK: - private Properties

	private let investmentFilterDidTap: () -> Void

	// MARK: - Public Properties

	public var investableAssets: [InvestableAssetViewModel]?
	public var userInvestments: [InvestAssetViewModel]

	// MARK: - Initializers

	init(
		userInvestments: [InvestAssetViewModel],
		investableAssets: [InvestableAssetViewModel]?,
		filterDidTap: @escaping () -> Void
	) {
		self.userInvestments = userInvestments
		self.investableAssets = investableAssets
		self.investmentFilterDidTap = filterDidTap
	}

	// MARK: - Internal Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if investableAssets != nil {
			return 2
		} else {
			return 1
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Constant number for skeleton loading
		guard let investableAssets else {
			return 6
		}
		switch section {
		case 0:
			return userInvestments.count
		case 1:
			return investableAssets.count
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		guard let investableAssets else {
			let AssetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: AssetsCollectionViewCell.cellReuseID,
				for: indexPath
			) as! AssetsCollectionViewCell
			AssetCell.assetVM = nil
			AssetCell.showSkeletonView()
			return AssetCell
		}
		switch indexPath.section {
		case 0:
			let AssetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: UserInvestmentAssetCell.cellReuseID,
				for: indexPath
			) as! UserInvestmentAssetCell
			AssetCell.investmentAsset = userInvestments[indexPath.item]
			AssetCell.setCellStyle(currentItem: indexPath.item, itemsCount: userInvestments.count)
			return AssetCell
		case 1:
			let AssetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: InvestableAssetCell.cellReuseID,
				for: indexPath
			) as! InvestableAssetCell
			AssetCell.investableAsset = investableAssets[indexPath.item]
			AssetCell.setCellStyle(currentItem: indexPath.item, itemsCount: investableAssets.count)
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
			if investableAssets != nil {
				headerView.title = "My investments"
				headerView.hasFilter = false
			}
		case 1:
			headerView.title = "Investable assets"
			headerView.hasFilter = false
			headerView.filterDidTap = investmentFilterDidTap
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return headerView
	}
}
