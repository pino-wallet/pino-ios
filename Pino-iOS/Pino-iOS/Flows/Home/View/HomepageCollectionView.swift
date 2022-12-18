//
//  HomepageCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/18/22.
//

import UIKit

class HomepageCollectionView: UICollectionView {
	// MARK: Initializers

	convenience init() {
		// Set flow layout for collection view
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
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
		register(IntroCollectionViewCell.self, forCellWithReuseIdentifier: IntroCollectionViewCell.cellReuseID)
		register(
			HomepageHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: HomepageHeaderView.headerReuseID
		)
		dataSource = self
		delegate = self
		showsHorizontalScrollIndicator = false
	}

	private func setupStyle() {
		backgroundColor = .Pino.clear
	}
}

// MARK: Collection View DataSource

extension HomepageCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		100
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: IntroCollectionViewCell.cellReuseID,
			for: indexPath
		) as! IntroCollectionViewCell
		assetCell.introModel = IntroModel(image: "", title: "asset", description: "")
		return assetCell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(
			ofKind: kind,
			withReuseIdentifier: HomepageHeaderView.headerReuseID,
			for: indexPath
		) as! HomepageHeaderView
		headerView.title = "header"
		return headerView
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 60)
	}
}

// MARK: Collection View Delegate

extension HomepageCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: Collection View Flow Layout

extension HomepageCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 60)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		0
	}
}
