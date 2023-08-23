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

	public var investableAssets: [InvestableAssetViewModel]
	public var userInvestments: [InvestAssetViewModel]

	// MARK: - Initializers

	init(
		userInvestments: [InvestAssetViewModel],
		investableAssets: [InvestableAssetViewModel],
		filterDidTap: @escaping () -> Void
	) {
		self.userInvestments = userInvestments
		self.investableAssets = investableAssets
		self.investmentFilterDidTap = filterDidTap
	}

	// MARK: - Internal Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if userInvestments.isEmpty {
			return 1
		} else {
			return 2
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
			headerView.title = "My investments"
			headerView.hasFilter = false
		case 1:
			headerView.title = "Investable assets"
			headerView.hasFilter = true
			headerView.filterDidTap = investmentFilterDidTap
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return headerView
	}
}