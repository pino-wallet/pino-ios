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
			volatilityType: .profit
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
		let assetsModel = [
			AssetModel(
				image: "cETH",
				name: "cETH",
				codeName: "ETH",
				amount: "1.2",
				amountInDollor: "1,530",
				volatilityInDollor: "10",
				volatilityType: "profit",
				isSelected: false
			),
			AssetModel(
				image: "aDAI",
				name: "aDAI",
				codeName: "aDAI",
				amount: "10.2",
				amountInDollor: "10,3",
				volatilityInDollor: "14",
				volatilityType: "profit",
				isSelected: false
			),
			AssetModel(
				image: "Sand",
				name: "Sand",
				codeName: "SAND",
				amount: "10,04",
				amountInDollor: "1,530",
				volatilityInDollor: "10",
				volatilityType: "profit",
				isSelected: false
			),
			AssetModel(
				image: "Status",
				name: "Status",
				codeName: "SNT",
				amount: "4,330",
				amountInDollor: "1,530",
				volatilityInDollor: "115",
				volatilityType: "profit",
				isSelected: false
			),
			AssetModel(
				image: "DAI",
				name: "DAI",
				codeName: "DAI",
				amount: "1.049",
				amountInDollor: "1,530",
				volatilityInDollor: "3.5",
				volatilityType: "loss",
				isSelected: false
			),
			AssetModel(
				image: "USDC",
				name: "USDC",
				codeName: "USDC",
				amount: "0",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: false
			),
		]

		positionAssetsList = assetsModel.compactMap { AssetViewModel(assetModel: $0) }
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
		let manageAssetsModel = [
			AssetModel(
				image: "Chainlink",
				name: "Chainlink",
				codeName: "Link",
				amount: "10,04",
				amountInDollor: "1,530",
				volatilityInDollor: "10",
				volatilityType: "profit",
				isSelected: true
			),
			AssetModel(
				image: "Ribon",
				name: "Ribon",
				codeName: "RBN",
				amount: "4,330",
				amountInDollor: "1,420",
				volatilityInDollor: "115",
				volatilityType: "profit",
				isSelected: true
			),
			AssetModel(
				image: "Tether",
				name: "Tether",
				codeName: "USDT",
				amount: "1.049",
				amountInDollor: "1,130",
				volatilityInDollor: "3.5",
				volatilityType: "loss",
				isSelected: true
			),
			AssetModel(
				image: "BTC",
				name: "BTC",
				codeName: "BTC",
				amount: "0",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: true
			),
			AssetModel(
				image: "cETH",
				name: "cETH",
				codeName: "ETH",
				amount: "1.2",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: false
			),
			AssetModel(
				image: "aDAI",
				name: "aDAI",
				codeName: "aDAI",
				amount: "10.2",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: false
			),
			AssetModel(
				image: "Sand",
				name: "Sand",
				codeName: "SAND",
				amount: "10,04",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: false
			),
			AssetModel(
				image: "Status",
				name: "Status",
				codeName: "SNT",
				amount: "4,330",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: false
			),
			AssetModel(
				image: "DAI",
				name: "DAI",
				codeName: "DAI",
				amount: "1.049",
				amountInDollor: "0",
				volatilityInDollor: "0",
				volatilityType: "none",
				isSelected: false
			),
		]
		do {
			let encodedAssets = try JSONEncoder().encode(manageAssetsModel)
			UserDefaults.standard.register(defaults: ["assets": encodedAssets])
		} catch {
			print(error)
			UserDefaults.standard.register(defaults: ["assets": []])
		}
	}

	// MARK: - The end of temporary Methods
}
