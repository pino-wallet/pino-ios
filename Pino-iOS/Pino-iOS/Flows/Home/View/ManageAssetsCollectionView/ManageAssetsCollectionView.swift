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
	private let positionsIsSelected: (Bool) -> Void
	private let asssetIsSelected: ((selectedAsset: AssetViewModel, isSelected: Bool)) -> Void
	private let hapticManager = HapticManager()

	// MARK: - Public Properties

	public var filteredAssets: [AssetViewModel]
	public var positionsVM: ManageAssetPositionsViewModel?

	// MARK: Initializers

	init(
		assets: [AssetViewModel],
		positionsVM: ManageAssetPositionsViewModel,
		positionsIsSelected: @escaping (Bool) -> Void,
		assetIsSelected: @escaping ((selectedAsset: AssetViewModel, isSelected: Bool)) -> Void
	) {
		self.filteredAssets = assets
		self.positionsVM = positionsVM
		self.positionsIsSelected = positionsIsSelected
		self.asssetIsSelected = assetIsSelected
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
			if let positionsVM {
				return 1
			} else {
				return 0
			}
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
		hapticManager.run(type: .selectionChanged)
		if indexPath.section == 0 {
			let positionsCell = cellForItem(at: indexPath) as! ManageAssetPositionsCell
			positionsCell.toggleAssetSwitch()
			positionsIsSelected(positionsCell.isSwitchOn())
		} else {
			let manageAssetCell = cellForItem(at: indexPath) as! ManageAssetCell
			manageAssetCell.toggleAssetSwitch()
			asssetIsSelected((filteredAssets[indexPath.item], manageAssetCell.isSwitchOn()))
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

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		if section == 0 {
			UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		} else {
			.zero
		}
	}
}
