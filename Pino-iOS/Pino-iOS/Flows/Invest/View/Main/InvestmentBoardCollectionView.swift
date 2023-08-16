//
//  InvestmentBoardCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import UIKit

class InvestmentBoardCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let assets: [InvestAssetViewModel]
	private let assetDidSelect: (InvestAssetViewModel) -> Void

	// MARK: - Initializers

	init(assets: [InvestAssetViewModel], assetDidSelect: @escaping (InvestAssetViewModel) -> Void) {
		self.assets = assets
		self.assetDidSelect = assetDidSelect
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configureCollectionView()
		setupStyle()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		delegate = self
		dataSource = self

		register(
			InvestmentBoardHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: InvestmentBoardHeaderView.viewReuseID
		)
		register(InvestmentBoardCell.self, forCellWithReuseIdentifier: InvestmentBoardCell.cellReuseID)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
	}
}

extension InvestmentBoardCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			assetDidSelect(assets[indexPath.item])
		case 1:
			return assetDidSelect(assets[indexPath.item])
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}
}

extension InvestmentBoardCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if assets.isEmpty || assets.isEmpty {
			return 1
		} else {
			return 2
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 2
		case 1:
			return assets.count
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let investmentBoardCell = dequeueReusableCell(
			withReuseIdentifier: InvestmentBoardCell.cellReuseID,
			for: indexPath
		) as! InvestmentBoardCell
		switch indexPath.section {
		case 0:
			investmentBoardCell.asset = assets[indexPath.item]
			investmentBoardCell.setCellStyle(currentItem: indexPath.item, itemsCount: 2)
		case 1:
			investmentBoardCell.asset = assets[indexPath.item]
			investmentBoardCell.setCellStyle(currentItem: indexPath.item, itemsCount: assets.count)
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return investmentBoardCell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let headerView = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: InvestmentBoardHeaderView.viewReuseID,
			for: indexPath
		) as! InvestmentBoardHeaderView
		switch indexPath.section {
		case 0:
			headerView.title = "My investments"
		case 1:
			headerView.title = "Investable assets"
			headerView.hasFilter = true
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
		return headerView
	}
}

extension InvestmentBoardCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 64)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 54)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
	}
}
