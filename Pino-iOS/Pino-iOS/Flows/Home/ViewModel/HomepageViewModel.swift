//
//  HomepageViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import Combine
import Foundation
import Network

class HomepageViewModel {
	// MARK: - Public Properties

	@Published
	public var walletInfo: WalletInfoViewModel!
	@Published
	public var walletBalance: WalletBalanceViewModel!
	@Published
	public var assetsList: [AssetViewModel]!
	@Published
	public var positionAssetsList: [AssetViewModel]!
	@Published
	public var securityMode = false
	@Published
	public var manageAssetsList: [ManageAssetViewModel]!

	public let copyToastMessage = "Copied!"
	public let connectionErrorToastMessage = "No internet connection"
	public let requestFailedErrorToastMessage = "Couldn't refresh home data"
	public let sendButtonTitle = "Send"
	public let recieveButtonTitle = "Recieve"
	public let sendButtonImage = "arrow.up"
	public let recieveButtonImage = "arrow.down"

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()
	private var assetsAPIClient = AssetsAPIMockClient()

	// MARK: - Initializers

	init() {
		getWalletInfo()
		getWalletBalance()
		getManageAssetsList()
		getAssetsList()
		getPositionAssetsList()
		setupBindings()
	}

	// MARK: - Public Methods

	public func refreshHomeData(completion: @escaping (HomeRefreshError?) -> Void) {
		// This is temporary and must be replaced with network request
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				if path.status == .satisfied {
					self.getWalletBalance()
					self.getAssetsList()
					self.getPositionAssetsList()
					completion(nil)
					monitor.cancel()
				} else {
					completion(.networkConnection)
					monitor.cancel()
				}
			}
		}
		let queue = DispatchQueue(label: "InternetConnectionMonitor")
		monitor.start(queue: queue)
	}

	// MARK: - Private Methods

	private func setupBindings() {
		$securityMode.sink { [weak self] securityMode in
			guard let self = self else { return }
			if securityMode {
				self.enableSecurityMode()
			} else {
				self.disableSecurityMode()
			}
		}.store(in: &cancellables)
	}

	private func enableSecurityMode() {
		walletBalance.enableSecurityMode()

		for asset in assetsList {
			asset.enableSecurityMode()
		}
		for asset in positionAssetsList {
			asset.enableSecurityMode()
		}

		assetsList = assetsList
		positionAssetsList = positionAssetsList
	}

	private func disableSecurityMode() {
		walletBalance.disableSecurityMode()

		for asset in assetsList {
			asset.disableSecurityMode()
		}
		for asset in positionAssetsList {
			asset.disableSecurityMode()
		}

		assetsList = assetsList
		positionAssetsList = positionAssetsList
	}

	#warning("all the following functions are temporary and must be replaced by network requests")

	// MARK: - temporary Methods

	private func getWalletInfo() {
		// Request to get wallet info
		let walletInfoModel = WalletInfoModel(
			name: "Amir",
			address: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			profileImage: "avocado",
			profileColor: "Green 1 Color"
		)
		walletInfo = WalletInfoViewModel(walletInfoModel: walletInfoModel)
	}

	private func getWalletBalance() {
		// Request to get balance
		let balanceModel = WalletBalanceModel(
			balance: "12,568,000",
			volatilityPercentage: "5.6",
			volatilityInDollor: "58.67",
			volatilityType: "profit"
		)
		walletBalance = WalletBalanceViewModel(balanceModel: balanceModel)
	}

	private func getAssetsList() {
		$manageAssetsList.sink { [weak self] manageAssetsList in
			guard let self = self else { return }
			guard let manageAssetsList = manageAssetsList else { return }
			let assetsModel = manageAssetsList.compactMap { $0.assetModel }.filter { $0.isSelected == true }
			self.assetsList = assetsModel.compactMap { AssetViewModel(assetModel: $0) }
		}.store(in: &cancellables)
	}

	private func getPositionAssetsList() {
		assetsAPIClient.positions().sink { completed in
			switch completed {
			case .finished:
				print("Positions received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { positions in
			self.positionAssetsList = positions.positionsList.compactMap { AssetViewModel(assetModel: $0) }
		}.store(in: &cancellables)
	}

	private func getManageAssetsList() {
		registerAssetsUserDefaults()
		let manageAssetsModel = getAssetsFromUserDefaults()
		manageAssetsList = manageAssetsModel.compactMap { ManageAssetViewModel(assetModel: $0) }
	}

	public func saveAssetsInUserDefaults(assets: [AssetModel]) {
		do {
			let encodedAssets = try JSONEncoder().encode(assets)
			UserDefaults.standard.set(encodedAssets, forKey: "assets")
		} catch {
			UserDefaults.standard.set([], forKey: "assets")
		}
	}

	public func getAssetsFromUserDefaults() -> [AssetModel] {
		guard let encodedAssets = UserDefaults.standard.data(forKey: "assets") else { return [] }
		do {
			return try JSONDecoder().decode([AssetModel].self, from: encodedAssets)
		} catch {
			print(error)
			return []
		}
	}

	public func registerAssetsUserDefaults() {
		assetsAPIClient.assets().sink { completed in
			switch completed {
			case .finished:
				print("Assets received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { assets in
			do {
				let encodedAssets = try JSONEncoder().encode(assets.assetsList)
				UserDefaults.standard.register(defaults: ["assets": encodedAssets])
			} catch {
				print(error)
				UserDefaults.standard.register(defaults: ["assets": []])
			}
		}.store(in: &cancellables)
	}

	// MARK: - The end of temporary Methods
}
