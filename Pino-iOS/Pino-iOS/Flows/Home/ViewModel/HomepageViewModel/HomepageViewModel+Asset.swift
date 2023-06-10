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
			let customAssets = self.getCustomAssets()
			self.tokens = tokens + customAssets
			completion(.success(self.tokens!))
		}.store(in: &cancellables)
	}

	#warning("This is temporary and must be replaced with API data")
	internal func getPositionAssetsList() {
		positionAssetsList = []
	}

	internal func getCustomAssets() -> [Detail] {
		let customAssets = coreDataManager.getAllCustomAssets().compactMap {
			Detail(
				id: $0.id,
				symbol: $0.symbol,
				name: $0.name,
				logo: "unverified_asset",
				decimals: Int($0.decimal) ?? 0,
				change24H: "0",
				changePercentage: "0",
				price: "0",
				isVerified: false
			)
		}
		return customAssets
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

	private func addSelectedAssetToCoreData(id: String) {
		let selectedAsset = coreDataManager.addNewSelectedAsset(id: id)
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

	public func addNewCustomAsset(_ customAsset: CustomAsset) {
		addSelectedAssetToCoreData(id: customAsset.id)
		let customAssetDetail = Detail(
			id: customAsset.id,
			symbol: customAsset.symbol,
			name: customAsset.name,
			logo: "unverified_asset",
			decimals: Int(customAsset.decimal) ?? 0,
			change24H: "0",
			changePercentage: "0",
			price: "0",
			isVerified: false
		)
		tokens?.append(customAssetDetail)
		getHomeData { _ in }
	}

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
