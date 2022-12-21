//
//  AssetsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/20/22.
//

import Combine
import UIKit

class AssetsCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var homeVM: HomepageViewModel!
	private var cancellables = Set<AnyCancellable>()

	// MARK: Initializers

	convenience init(homeVM: HomepageViewModel) {
		// Set flow layout for collection view
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		flowLayout.scrollDirection = .vertical
		self.init(frame: .zero, collectionViewLayout: flowLayout)

		self.homeVM = homeVM
		configCollectionView()
		setupStyle()
	}

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		setupBindings()
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

	private func setupStyle() {
		backgroundColor = .Pino.clear
		showsVerticalScrollIndicator = false
	}

	private func setupBindings() {
		homeVM?.$assetsList.sink { [weak self] _ in
			self?.reloadSections(IndexSet(integer: 0))
		}.store(in: &cancellables)

		homeVM?.$positionAssetsList.sink { [weak self] _ in
			self?.reloadSections(IndexSet(integer: 1))
		}.store(in: &cancellables)
	}
}

// MARK: Collection View DataSource

extension AssetsCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		section == 0 ? homeVM.assetsList.count : homeVM.positionAssetsList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: AssetsCollectionViewCell.cellReuseID,
			for: indexPath
		) as! AssetsCollectionViewCell
		if indexPath.section == 0 {
			assetCell.assetVM = homeVM.assetsList[indexPath.row]
		} else {
			assetCell.assetVM = homeVM.positionAssetsList[indexPath.row]
		}
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
			return CGSize(width: collectionView.frame.width, height: 204)
		} else {
			return CGSize(width: collectionView.frame.width, height: 46)
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
		CGSize(width: collectionView.frame.width, height: 72)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		0
	}
}
