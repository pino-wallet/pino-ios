//
//  InvestmentAssetsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import UIKit

class InvestmentAssetsCollectionView: UICollectionView {
	// MARK: Public Properties

	public var assets: [InvestAssetViewModel]?

	// MARK: Initializers

	convenience init() {
		// Set flow layout for collection view
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		flowLayout.scrollDirection = .horizontal
		// It should be refactored later. section inset causes bugs in the view
//		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
		self.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
	}

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(InvestmentAssetCell.self, forCellWithReuseIdentifier: InvestmentAssetCell.cellReuseID)
		dataSource = self
		showsHorizontalScrollIndicator = false
	}

	private func setupStyle() {
		backgroundColor = .Pino.clear
	}
}

// MARK: Collection View DataSource

extension InvestmentAssetsCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assets?.count ?? 4
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: InvestmentAssetCell.cellReuseID,
			for: indexPath
		) as! InvestmentAssetCell
		assetCell.asset = assets?[indexPath.item] ?? nil
		return assetCell
	}
}
