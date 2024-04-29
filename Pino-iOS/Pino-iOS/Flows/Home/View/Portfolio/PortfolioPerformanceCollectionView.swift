//
//  PortfolioPerformanceView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/27/23.
//

import UIKit

class PortfolioPerformanceCollectionView: UICollectionView {
	// MARK: Private Properties

	private let portfolioPerformanceVM: PortfolioPerformanceViewModel
	private let hapticManager = HapticManager()

	// MARK: Public Properties

	public var assetSelected: (ShareOfAssetsProtocol) -> Void

	// MARK: Initializers

	init(
		portfolioPerformanceVM: PortfolioPerformanceViewModel,
		assetSelected: @escaping (ShareOfAssetsProtocol) -> Void
	) {
		self.portfolioPerformanceVM = portfolioPerformanceVM
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
			PortfolioPerformanceCell.self,
			forCellWithReuseIdentifier: PortfolioPerformanceCell.cellReuseID
		)
		register(
			PortfolioPerformanceHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: PortfolioPerformanceHeaderView.headerReuseID
		)

		register(
			PortfolioFooterView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: PortfolioFooterView.footerReuseID
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

extension PortfolioPerformanceCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 68)
	}
}

// MARK: - CollectionView Delegate

extension PortfolioPerformanceCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		hapticManager.run(type: .lightImpact)
		guard let assetsList = portfolioPerformanceVM.shareOfAssetsVM else { return }
		assetSelected(assetsList[indexPath.item])
	}
}

// MARK: - CollectionView DataSource

extension PortfolioPerformanceCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let assetsList = portfolioPerformanceVM.shareOfAssetsVM else { return 4 }
		return assetsList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = dequeueReusableCell(
			withReuseIdentifier: PortfolioPerformanceCell.cellReuseID,
			for: indexPath
		) as! PortfolioPerformanceCell
		if let assetsList = portfolioPerformanceVM.shareOfAssetsVM {
			assetCell.assetVM = assetsList[indexPath.item]
			assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: assetsList.count)
			assetCell.hideSkeletonView()
		} else {
			assetCell.assetVM = nil
			assetCell.setCellStyle(currentItem: indexPath.item, itemsCount: 4)
			assetCell.showSkeletonView()
		}
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
				withReuseIdentifier: PortfolioPerformanceHeaderView.headerReuseID,
				for: indexPath
			) as! PortfolioPerformanceHeaderView
			chartHedear.portfolioPerformanceVM = portfolioPerformanceVM
			return chartHedear
		case UICollectionView.elementKindSectionFooter:
			let chartFooter = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: PortfolioFooterView.footerReuseID,
				for: indexPath
			) as! PortfolioFooterView
			chartFooter.footerVM = PortfolioFooterViewModel()
			return chartFooter
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

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		if let assetsList = portfolioPerformanceVM.shareOfAssetsVM, assetsList.isEmpty {
			return CGSize(width: collectionView.frame.width - 32, height: 204)
		}
		return CGSize(width: 0, height: 0)
	}
}
