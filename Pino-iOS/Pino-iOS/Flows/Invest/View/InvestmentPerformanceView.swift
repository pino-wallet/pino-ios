//
//  InvestmentPerformanceView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation
import UIKit

class InvestmentPerformanceCollectionView: UICollectionView {
	// MARK: Private Properties

	private let investmentPerformanceVM: InvestmentPerformanceViewModel

	// MARK: Public Properties

	public var assetSelected: (ShareOfAssetsProtocol) -> Void

	// MARK: Initializers

	init(
		investmentPerformanceVM: InvestmentPerformanceViewModel,
		assetSelected: @escaping (ShareOfAssetsProtocol) -> Void
	) {
		self.investmentPerformanceVM = investmentPerformanceVM
		self.assetSelected = assetSelected
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
		setupBindings()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(
			InvestmentPerformanceAssetCell.self,
			forCellWithReuseIdentifier: InvestmentPerformanceAssetCell.cellReuseID
		)
		register(
			InvestmentPerformanceHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: InvestmentPerformanceHeaderView.headerReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}

	private func setupBindings() {}
}

// MARK: - Collection View Flow Layout

extension InvestmentPerformanceCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 68)
	}
}

// MARK: - CollectionView Delegate

extension InvestmentPerformanceCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		assetSelected(investmentPerformanceVM.shareOfAssetsVM[indexPath.item])
	}
}

// MARK: - CollectionView DataSource

extension InvestmentPerformanceCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		investmentPerformanceVM.shareOfAssetsVM.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = dequeueReusableCell(
			withReuseIdentifier: InvestmentPerformanceAssetCell.cellReuseID,
			for: indexPath
		) as! InvestmentPerformanceAssetCell
		assetCell.assetVM = investmentPerformanceVM.shareOfAssetsVM[indexPath.item]
		assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: investmentPerformanceVM.shareOfAssetsVM.count)
		return assetCell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let chartHedear = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: InvestmentPerformanceHeaderView.headerReuseID,
				for: indexPath
			) as! InvestmentPerformanceHeaderView
			chartHedear.investmentPerformanceVM = investmentPerformanceVM
			return chartHedear
		default:
			fatalError("Invalid element type")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		let indexPath = IndexPath(row: 0, section: section)
		let headerView = self.collectionView(
			collectionView,
			viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
			at: indexPath
		)
		return headerView.systemLayoutSizeFitting(
			CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
	}
}
