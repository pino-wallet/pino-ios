//
//  HomepageViewModel+Asset.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/13/23.
//

import Combine
import CoreData
import PromiseKit

class AssetManagerViewModel {
	// MARK: - Public Accessor

	public static let shared = AssetManagerViewModel()

	// MARK: - Private Initiliazer

	private var tokens: [Detail] = []
	private init() {}

	// MARK: - Public Properties

	public var selectedAssets = [SelectedAsset]()

	@Published
	public var assetsModelList: [AssetProtocol]!
	@Published
	public var positionAssetsList: [AssetViewModel]?

	// MARK: - Private Properties

	private let accountingAPIClient = AccountingAPIClient()
	private let ctsAPIclient = CTSAPIClient()
	private let coreDataManager = CoreDataManager()
	private var cancellables = Set<AnyCancellable>()

	internal func getAssetsList() -> Promise<[AssetViewModel]> {
		Promise<[AssetViewModel]> { seal in
			firstly {
				getTokens()
			}.done { [self] tokens in
				accountingAPIClient.userBalance()
					.sink { completed in
						switch completed {
						case .finished:
							print("Assets received successfully")
						case let .failure(error):
							print("Error getting tokens:\(error)")
							seal.reject(APIError.failedRequest)
						}
					} receiveValue: { assets in
						let managedAssets = self.getManageAsset(tokens: tokens, userAssets: assets)
						seal.fulfill(managedAssets)
					}.store(in: &cancellables)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	internal func getManageAsset(tokens: [Detail], userAssets: [BalanceAssetModel]) -> [AssetViewModel] {
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
		let tokens = tokensModel.compactMap {
			AssetViewModel(assetModel: $0, isSelected: self.selectedAssets.map { $0.id }.contains($0.id))
		}
		return tokens
	}

	internal func getTokens() -> Promise<[Detail]> {
		Promise<[Detail]> { seal in
			ctsAPIclient.tokens().sink { completed in
				switch completed {
				case .finished:
					print("tokens received successfully")
				case let .failure(error):
					print("Failed to fetch tokens:\(error)")
					seal.reject(APIError.failedRequest)
				}
			} receiveValue: { tokens in
				let customAssets = self.getCustomAssets()
				self.tokens = tokens + customAssets
				seal.fulfill(self.tokens)
			}.store(in: &cancellables)
		}
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
		tokens.append(customAssetDetail)
		GlobalVariables.shared.fetchSharedInfo()
	}

	public func updateSelectedAssets(_ selectedAsset: AssetViewModel, isSelected: Bool) {
		guard let manageAssetsList = GlobalVariables.shared.manageAssetsList else { return }
		if let selectedAssetIndex = manageAssetsList.firstIndex(where: {
			$0.id == selectedAsset.id
		}) {
			let updatedAssets = manageAssetsList
			updatedAssets[selectedAssetIndex].toggleIsSelected()
			GlobalVariables.shared.manageAssetsList = updatedAssets
			if isSelected {
				addSelectedAssetToCoreData(manageAssetsList[selectedAssetIndex])
			} else {
				deleteSelectedAssetFromCoreData(manageAssetsList[selectedAssetIndex])
			}
		}
	}

	#warning("This is temporary and must be replaced with API data")
	internal func getPositionAssetsList() {
		positionAssetsList = []
	}
}
