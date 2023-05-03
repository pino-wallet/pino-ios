//
//  HomepageViewModel+Asset.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/13/23.
//

import CoreData

extension HomepageViewModel {
	// MARK: Internal Methods

	internal func getAssetsList(completion: @escaping (_ assets: [BalanceAssetModel]?, _ error: APIError?) -> Void) {
		accountingAPIClient.userBalance()
			.map { balanceAssets in
				balanceAssets.filter { $0.isVerified }
			}
			.sink { completed in
				switch completed {
				case .finished:
					print("Assets received successfully")
				case let .failure(error):
					completion(nil, error)
					print(error)
				}
			} receiveValue: { assets in
				completion(assets, nil)
			}.store(in: &cancellables)
	}

	internal func getManageAsset(assets: [BalanceAssetModel]) {
		assetsModelList = assets
		checkDefaultAssetsAdded(assets)
		let selectedAssetsID = selectedAssets.map { $0.id }
		manageAssetsList = assets.compactMap {
			AssetViewModel(assetModel: $0, isSelected: selectedAssetsID.contains($0.id))
		}
	}

	#warning("This is temporary and must be replaced with API data")
	internal func getPositionAssetsList() {
		positionAssetsList = []
	}

	#warning("Core data functions should be moved to a separate layer")

	internal func getSelectedAssetsFromCoreData() {
		let selectedAssetsFetch: NSFetchRequest<SelectedAsset> = SelectedAsset.fetchRequest()
		do {
			let results = try managedContext.fetch(selectedAssetsFetch)
			selectedAssets = results
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	internal func checkDefaultAssetsAdded(_ assets: [BalanceAssetModel]) {
		let defaultAssetUserDefaultsKey = "isDefaultAssetsAdded"
		if !UserDefaults.standard.bool(forKey: defaultAssetUserDefaultsKey) {
			addDefaultAssetsToCoreData(assets)
			UserDefaults.standard.setValue(true, forKey: defaultAssetUserDefaultsKey)
		}
	}

	// MARK: Private Methods

	private func insertSelectedAssetInCoreData(_ asset: AssetViewModel) {
		let newAsset = SelectedAsset(context: managedContext)
		newAsset.setValue(asset.id, forKey: "id")
		selectedAssets.append(newAsset)
		// Save changes in CoreData
		coreDataStack.saveContext()
	}

	private func deleteSelectedAssetFromCoreData(_ asset: AssetViewModel) {
		guard let selectedAsset = selectedAssets.first(where: { $0.id == asset.id }) else { return }
		managedContext.delete(selectedAsset)
		selectedAssets.removeAll(where: { $0.id == asset.id })
		// Save changes in CoreData
		coreDataStack.saveContext()
	}

	private func addDefaultAssetsToCoreData(_ assets: [BalanceAssetModel]) {
		let defaultAssets = assets.prefix(4)
		for asset in defaultAssets {
			let newDefaultAsset = SelectedAsset(context: managedContext)
			newDefaultAsset.setValue(asset.id, forKey: "id")
			selectedAssets.append(newDefaultAsset)
		}
		// Save changes in CoreData
		coreDataStack.saveContext()
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
