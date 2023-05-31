//
//  HomepageViewModel+Asset.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/13/23.
//

import CoreData

extension HomepageViewModel {
	// MARK: Internal Methods

	internal func getAssetsList(completion: @escaping (Result<[BalanceAssetModel], APIError>) -> Void) {
		if let tokens {
			accountingAPIClient.userBalance()
				.map { balanceAssets in
					balanceAssets.filter { $0.isVerified }
				}
				.sink { completed in
					switch completed {
					case .finished:
						print("Assets received successfully")
					case let .failure(error):
						completion(.failure(error))
					}
				} receiveValue: { assets in
					self.getManageAsset(tokens: tokens, userAssets: assets)
					completion(.success(assets))
				}.store(in: &cancellables)
		} else {
			getTokens { result in
				switch result {
				case .success:
					self.getAssetsList(completion: completion)
				case let .failure(error):
					completion(.failure(error))
				}
			}
		}
	}

	internal func getManageAsset(tokens: [Detail], userAssets: [BalanceAssetModel]) {
		let tokensModel = tokens.compactMap {
			let tokenID = $0.id
			let userAsset = userAssets.first(where: { $0.id == tokenID })
			return BalanceAssetModel(
				id: $0.id,
				amount: userAsset?.amount ?? "0",
				isVerified: userAsset?.isVerified ?? true,
				detail: $0,
				previousDayNetworth: userAsset?.previousDayNetworth ?? "0"
			)
		}
		assetsModelList = tokensModel
		manageAssetsList = tokensModel.compactMap {
			AssetViewModel(assetModel: $0, isSelected: self.selectedAssets.map { $0.id }.contains($0.id))
		}
	}

	internal func getTokens(completion: @escaping (Result<[Detail], APIError>) -> Void) {
		ctsAPIclient.tokens().sink { completed in
			switch completed {
			case .finished:
				print("tokens received successfully")
			case let .failure(error):
				completion(.failure(error))
			}
		} receiveValue: { tokens in
			self.tokens = tokens
			completion(.success(tokens))
		}.store(in: &cancellables)
	}

	#warning("This is temporary and must be replaced with API data")
	internal func getPositionAssetsList() {
		positionAssetsList = []
	}

	internal func getSelectedAssetsFromCoreData() {
		selectedAssets = coreDataManager.getAllSelectedAssets()
	}

	internal func checkDefaultAssetsAdded() {
		let defaultAssetUserDefaultsKey = "isDefaultAssetsAdded"
		if !UserDefaults.standard.bool(forKey: defaultAssetUserDefaultsKey) {
			addDefaultAssetsToCoreData()
			UserDefaults.standard.setValue(true, forKey: defaultAssetUserDefaultsKey)
		}
	}

	// MARK: Private Methods

	private func addSelectedAssetToCoreData(_ asset: AssetViewModel) {
		let selectedAsset = coreDataManager.addNewSelectedAsset(id: asset.id)
		selectedAssets.append(selectedAsset)
	}

	private func deleteSelectedAssetFromCoreData(_ asset: AssetViewModel) {
		guard let selectedAsset = selectedAssets.first(where: { $0.id == asset.id }) else { return }
		coreDataManager.deleteSelectedAsset(selectedAsset)
		selectedAssets.removeAll(where: { $0 == selectedAsset })
	}

	private func addDefaultAssetsToCoreData() {
		for tokenID in ctsAPIclient.defaultTokensID {
			let selectedAsset = coreDataManager.addNewSelectedAsset(id: tokenID)
			selectedAssets.append(selectedAsset)
		}
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
				addSelectedAssetToCoreData(manageAssetsList[selectedAssetIndex])
			} else {
				deleteSelectedAssetFromCoreData(manageAssetsList[selectedAssetIndex])
			}
		}
	}
}
