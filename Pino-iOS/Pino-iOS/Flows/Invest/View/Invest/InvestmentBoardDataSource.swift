//
//  InvestmentBoardDataSource.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import UIKit

class InvestmentBoardDataSource: NSObject, UICollectionViewDataSource {
	private let investmentBoardVM: InvestmentBoardViewModel

	init(investmentVM: InvestmentBoardViewModel) {
		self.investmentBoardVM = investmentVM
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if investmentBoardVM.userInvestments.isEmpty {
			return 1
		} else {
			return 2
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return investmentBoardVM.userInvestments.count
		case 1:
			return investmentBoardVM.investableAssets.count
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
			AssetCell.investmentAsset = investmentBoardVM.userInvestments[indexPath.item]
			AssetCell.setCellStyle(currentItem: indexPath.item, itemsCount: investmentBoardVM.userInvestments.count)
			return AssetCell
		case 1:
			let AssetCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: InvestableAssetCell.cellReuseID,
				for: indexPath
			) as! InvestableAssetCell
			AssetCell.investableAsset = investmentBoardVM.investableAssets[indexPath.item]
			AssetCell.setCellStyle(currentItem: indexPath.item, itemsCount: investmentBoardVM.investableAssets.count)
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
			headerView.title = investmentBoardVM.userInvestmentsTitle
		case 1:
			headerView.title = investmentBoardVM.investableAssetsTitle
			headerView.hasFilter = true
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return headerView
	}
}
