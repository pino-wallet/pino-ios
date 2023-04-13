//
//  HomepageViewModel+Asset.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/13/23.
//

import CoreData

extension HomepageViewModel {
	// MARK: Internal Methods

	internal func getAssetsList() {
		let selectedAssetsID = selectedAssets.map { $0.id }
		accountingAPIClient.userBalance()
			.map { balanceAssets in
				balanceAssets.filter { $0.isVerified }
			}
			.sink { completed in
				switch completed {
				case .finished:
					print("Assets received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { assets in
				self.manageAssetsList = assets.compactMap {
					AssetViewModel(assetModel: $0, isSelected: selectedAssetsID.contains($0.id))
				}
			}.store(in: &cancellables)
	}

	internal func getPositionAssetsList() {
		positionAssetsList = []
	}

	internal func getSelectedAssetsFromCoreData() {
		let selectedAssetsFetch: NSFetchRequest<SelectedAsset> = SelectedAsset.fetchRequest()
		do {
			let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
			let results = try managedContext.fetch(selectedAssetsFetch)
			selectedAssets = results
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: Private Methods

	private func insertSelectedAssetInCoreData(_ asset: AssetViewModel) {
		let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
		let newAsset = SelectedAsset(context: managedContext)
		newAsset.setValue(asset.id, forKey: "id")
		selectedAssets.append(newAsset)
		// Save changes in CoreData
		AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
	}

	private func deleteSelectedAssetFromCoreData(_ asset: AssetViewModel) {
		guard let selectedAsset = selectedAssets.first(where: { $0.id == asset.id }) else { return }
		AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(selectedAsset)
		selectedAssets.removeAll(where: { $0.id == asset.id })
		// Save changes in CoreData
		AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
	}

	// MARK: Public Methods

	public func updateSelectedAssets(_ selectedAsset: AssetViewModel, isSelected: Bool) {
		guard let manageAssetsList else { return }
		if let selectedAssetIndex = manageAssetsList.firstIndex(where: {
			$0.id == selectedAsset.id
		}) {
			let updatedAssets = manageAssetsList
			updatedAssets[selectedAssetIndex].toggleIsSelected()
			self.manageAssetsList = updatedAssets

			if isSelected {
				insertSelectedAssetInCoreData(manageAssetsList[selectedAssetIndex])
			} else {
				deleteSelectedAssetFromCoreData(manageAssetsList[selectedAssetIndex])
			}
		}
	}
}
