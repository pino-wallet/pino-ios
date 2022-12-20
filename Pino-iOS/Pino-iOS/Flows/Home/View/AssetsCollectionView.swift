//
//  AssetsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/20/22.
//

import UIKit

class AssetsCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var homeVM: HomepageViewModel!

	// MARK: Initializers

	convenience init(homeVM: HomepageViewModel) {
		// Set flow layout for collection view
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		flowLayout.scrollDirection = .vertical
		self.init(frame: .zero, collectionViewLayout: flowLayout)

		self.homeVM = homeVM
		configCollectionView()
	}

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(
			AssetsCollectionViewCell.self,
			forCellWithReuseIdentifier: AssetsCollectionViewCell.cellReuseID
		)
		register(
			HomepageHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: HomepageHeaderView.headerReuseID
		)
		register(
			PositionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: PositionHeaderView.headerReuseID
		)
		dataSource = self
		delegate = self
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		setupStyle()
	}

	private func setupStyle() {
		let backgroundGradientView = UIView()
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.locations = [0.2, 0.5]
		gradientLayer.colors = [
			UIColor.Pino.secondaryBackground.cgColor,
			UIColor.Pino.background.cgColor,
		]
		backgroundGradientView.layer.addSublayer(gradientLayer)
		backgroundView = backgroundGradientView
	}
}

// MARK: Collection View DataSource

extension AssetsCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		section == 0 ? 4 : 8
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: AssetsCollectionViewCell.cellReuseID,
			for: indexPath
		) as! AssetsCollectionViewCell
		assetCell.asset = ""
		return assetCell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		if indexPath.section == 0 {
			let homeHeaderView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: HomepageHeaderView.headerReuseID,
				for: indexPath
			) as! HomepageHeaderView
			homeHeaderView.homeVM = homeVM
			return homeHeaderView
		} else {
			let positionHeaderView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: PositionHeaderView.headerReuseID,
				for: indexPath
			) as! PositionHeaderView
			positionHeaderView.title = "Position"
			return positionHeaderView
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		if section == 0 {
			return CGSize(width: collectionView.frame.width, height: 208)
		} else {
			return CGSize(width: collectionView.frame.width, height: 54)
		}
	}
}

// MARK: Collection View Delegate

extension AssetsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: Collection View Flow Layout

extension AssetsCollectionView: UICollectionViewDelegateFlowLayout {
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
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		8
	}
}
