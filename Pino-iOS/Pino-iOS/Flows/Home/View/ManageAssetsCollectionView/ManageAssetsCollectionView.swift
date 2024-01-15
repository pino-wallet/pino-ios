//
//  ManageAssetsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

import Combine
import UIKit

class ManageAssetsCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var homeVM: HomepageViewModel
	public var filteredAssets: [AssetViewModel] {
		didSet {
			reloadData()
		}
	}

	public var positionsVM: ManageAssetPositionsViewModel

	// MARK: Initializers

	init(homeVM: HomepageViewModel) {
		self.homeVM = homeVM
		self.filteredAssets = GlobalVariables.shared.manageAssetsList?.filter { $0.isPosition == false } ?? []
		self.positionsVM = ManageAssetPositionsViewModel(
			positions: GlobalVariables.shared.manageAssetsList?.filter { $0.isPosition == true } ?? []
		)
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
			ManageAssetCell.self,
			forCellWithReuseIdentifier: ManageAssetCell.cellReuseID
		)

		register(
			ManageAssetPositionsCell.self,
			forCellWithReuseIdentifier: ManageAssetPositionsCell.cellReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}
}

// MARK: - CollectionView DataSource

extension ManageAssetsCollectionView: UICollectionViewDataSource {
	internal func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return filteredAssets.count
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		if indexPath.section == 0 {
			let positionsCell = dequeueReusableCell(
				withReuseIdentifier: ManageAssetPositionsCell.cellReuseID,
				for: indexPath
			) as! ManageAssetPositionsCell
			positionsCell.positionsVM = positionsVM
			return positionsCell
		} else {
			let assetCell = dequeueReusableCell(
				withReuseIdentifier: ManageAssetCell.cellReuseID,
				for: indexPath
			) as! ManageAssetCell
			assetCell.assetVM = filteredAssets[indexPath.item]
			return assetCell
		}
	}
}

// MARK: Collection Delegate

extension ManageAssetsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let positionsCell = cellForItem(at: indexPath) as! ManageAssetPositionsCell
			positionsCell.toggleAssetSwitch()
			AssetManagerViewModel.shared.updateSelectedPositions(positionsCell.isSwitchOn())
		} else {
			let manageAssetCell = cellForItem(at: indexPath) as! ManageAssetCell
			manageAssetCell.toggleAssetSwitch()
			AssetManagerViewModel.shared.updateSelectedAssets(
				filteredAssets[indexPath.item],
				isSelected: manageAssetCell.isSwitchOn()
			)
		}
	}
}

// MARK: Collection View Flow Layout

extension ManageAssetsCollectionView: UICollectionViewDelegateFlowLayout {
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
		.zero
	}
}
