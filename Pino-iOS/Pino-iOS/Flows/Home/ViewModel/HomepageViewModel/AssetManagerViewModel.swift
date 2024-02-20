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

	// MARK: - Private Properties

	private let accountingAPIClient = AccountingAPIClient()
	private let assetsAPIClient = AssetsAPIClient()
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
				amount: userAsset?.amount ?? "0", capital: userAsset?.capital ?? "0",
				detail: $0,
				previousDayNetworth: userAsset?.previousDayNetworth ?? "0"
			)
		}
		getSelectedAssets(tokensModel)
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
		let customAssets = coreDataManager.getAllCustomAssets()
			.filter { $0.accountAddress.lowercased() == PinoWalletManager().currentAccount.eip55Address.lowercased() }
			.compactMap {
				Detail(
					id: $0.id,
					symbol: $0.symbol,
					name: $0.name,
					logo: "unverified_asset", website: "-",
					decimals: Int($0.decimal) ?? 0,
					change24H: "0",
					changePercentage: "0",
					price: "0",
					isVerified: false,
					isPosition: false
				)
			}
		return customAssets
	}

	// MARK: - Private Methods

	private func getSelectedAssets(_ assets: [BalanceAssetModel]) {
		let currentAccount = PinoWalletManager().currentAccount
		if currentAccount.hasDefaultAssets {
			getSelectedAssetsFromCoreData()
		} else {
			addDefaultAssetsToCoreData(assets: assets)
		}
	}

	private func getSelectedAssetsFromCoreData() {
		let currentAccount = PinoWalletManager().currentAccount
		selectedAssets = currentAccount.selectedAssets.allObjects as! [SelectedAsset]
	}

	private func addSelectedAssetToCoreData(id: String) {
		let selectedAsset = coreDataManager.addNewSelectedAsset(id: id)
		selectedAssets.append(selectedAsset)
	}

	private func deleteSelectedAssetFromCoreData(_ asset: AssetViewModel) {
		let selectedAssets = selectedAssets.filter { $0.id == asset.id }
		for selectedAsset in selectedAssets {
			coreDataManager.deleteSelectedAsset(selectedAsset)
			self.selectedAssets.removeAll(where: { $0 == selectedAsset })
		}
	}

	private func addDefaultAssetsToCoreData(assets: [BalanceAssetModel]) {
		selectedAssets = []
		let userAssets = assets.compactMap { AssetViewModel(assetModel: $0, isSelected: false) }
			.filter { !$0.isPosition && !$0.holdAmount.isZero }
		if userAssets.isEmpty {
			for tokenID in ctsAPIclient.defaultTokensID {
				addSelectedAssetToCoreData(id: tokenID)
			}
			return
		}
		for asset in userAssets {
			addSelectedAssetToCoreData(id: asset.id)
		}
	}

	// MARK: - Public Methods

	public func getPositionAssetDetails() -> Promise<[PositionAssetModel]> {
		Promise<[PositionAssetModel]> { seal in
			assetsAPIClient.getAllPositionAssets().sink { completed in
				switch completed {
				case .finished:
					print("tokens received successfully")
				case let .failure(error):
					print("Failed to fetch position asset details:\(error)")
					Toast.default(title: "Failed to get position assets", style: .error).show(haptic: .warning)
				}
			} receiveValue: { positionAssets in
				seal.fulfill(positionAssets)
			}.store(in: &cancellables)
		}
	}

	public func addNewCustomAsset(_ customAsset: CustomAsset) {
		addSelectedAssetToCoreData(id: customAsset.id)
		let customAssetDetail = Detail(
			id: customAsset.id,
			symbol: customAsset.symbol,
			name: customAsset.name,
			logo: "unverified_asset", website: "-",
			decimals: Int(customAsset.decimal) ?? 0,
			change24H: "0",
			changePercentage: "0",
			price: "0",
			isVerified: false,
			isPosition: false
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
				addSelectedAssetToCoreData(id: manageAssetsList[selectedAssetIndex].id)
			} else {
				deleteSelectedAssetFromCoreData(manageAssetsList[selectedAssetIndex])
			}
		}
	}

	public func updateSelectedPositions(_ isSelected: Bool) {
		guard let manageAssetsList = GlobalVariables.shared.manageAssetsList else { return }
		ManageAssetPositionsViewModel.positionsSelected = isSelected
		GlobalVariables.shared.manageAssetsList = manageAssetsList
	}
}
