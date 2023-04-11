//
//  ManageAssetsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

import UIKit

class ManageAssetsCollectionView: UICollectionView {
	// MARK: - Public Properties

	public var homeVM: HomepageViewModel
	public var filteredAssets: [AssetViewModel] {
		didSet {
			reloadData()
		}
	}

	// MARK: Initializers

	init(homeVM: HomepageViewModel) {
		self.homeVM = homeVM
		self.filteredAssets = homeVM.manageAssetsList
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
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		filteredAssets.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let assetCell = dequeueReusableCell(
			withReuseIdentifier: ManageAssetCell.cellReuseID,
			for: indexPath
		) as! ManageAssetCell
		assetCell.assetVM = filteredAssets[indexPath.item]
		return assetCell
	}
}

// MARK: Collection Delegate

extension ManageAssetsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let manageAssetCell = cellForItem(at: indexPath) as! ManageAssetCell
		manageAssetCell.toggleAssetSwitch()
		updateManageAssetSelection(assetIndex: indexPath.item, isSelected: manageAssetCell.isSwitchOn())
	}

	private func updateManageAssetSelection(assetIndex: Int, isSelected: Bool) {
		if let selectedAssetIndex = homeVM.manageAssetsList.firstIndex(where: {
			$0.id == filteredAssets[assetIndex].id
		}) {
			let updatedAssets = homeVM.manageAssetsList
			updatedAssets?[selectedAssetIndex].toggleIsSelected()
			homeVM.manageAssetsList = updatedAssets

			if isSelected {
				insertAssetInCoreData(homeVM.manageAssetsList[selectedAssetIndex])
			} else {
				deleteAssetFromCoreData(homeVM.manageAssetsList[selectedAssetIndex])
			}
		}
	}

	private func insertAssetInCoreData(_ asset: AssetViewModel) {
		let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
		let newAsset = SelectedAsset(context: managedContext)
		newAsset.setValue(asset.id, forKey: "id")
		homeVM.selectedAssets.append(newAsset)
		// Save changes in CoreData
		AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
	}

	private func deleteAssetFromCoreData(_ asset: AssetViewModel) {
		guard let selectedAsset = homeVM.selectedAssets.first(where: { $0.id == asset.id }) else { return }
		AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(selectedAsset)
		homeVM.selectedAssets.removeAll(where: { $0.id == asset.id })
		// Save changes in CoreData
		AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
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
		1
	}
}
