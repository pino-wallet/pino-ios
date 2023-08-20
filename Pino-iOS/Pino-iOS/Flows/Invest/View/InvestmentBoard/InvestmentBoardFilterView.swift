//
//  InvestmentBoardFilterView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import UIKit

class InvestmentBoardFilterView: UICollectionView {
	// MARK: - Private Properties

	private let filterVM: InvestmentBoardFilterViewModel

	// MARK: - Closures

	public var filterItemSelected: (InvestmentFilterItemViewModel) -> Void
	public var clearFiltersDidTap: () -> Void

	// MARK: - Initializers

	init(
		filterVM: InvestmentBoardFilterViewModel,
		filterItemSelected: @escaping (InvestmentFilterItemViewModel) -> Void,
		clearFiltersDidTap: @escaping () -> Void
	) {
		self.filterVM = filterVM
		self.filterItemSelected = filterItemSelected
		self.clearFiltersDidTap = clearFiltersDidTap
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(
			InvestmentBoardFilterCell.self,
			forCellWithReuseIdentifier: InvestmentBoardFilterCell.cellReuseID
		)
		register(
			InvestmentBoardFilterHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: InvestmentBoardFilterHeaderView.viewReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}
}

// MARK: - Collection View Flow Layout

extension InvestmentBoardFilterView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 48)
	}
}

// MARK: - CollectionView Delegate

extension InvestmentBoardFilterView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		filterItemSelected(filterVM.filters[indexPath.item])
	}
}

// MARK: - CollectionView DataSource

extension InvestmentBoardFilterView: UICollectionViewDataSource {
	internal func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}

	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		filterVM.filters.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let filterCell = dequeueReusableCell(
			withReuseIdentifier: InvestmentBoardFilterCell.cellReuseID,
			for: indexPath
		) as! InvestmentBoardFilterCell
		filterCell.filterItemVM = filterVM.filters[indexPath.item]
		filterCell.setCellStyle(currentItem: indexPath.item, itemsCount: filterVM.filters.count)
		return filterCell
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let filterHeaderView = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: InvestmentBoardFilterHeaderView.viewReuseID,
				for: indexPath
			) as! InvestmentBoardFilterHeaderView
			filterHeaderView.title = "Filter by"
			filterHeaderView.clearFiltersDidTap = clearFiltersDidTap
			return filterHeaderView
		default:
			fatalError("Invalid element type")
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 64)
	}
}
