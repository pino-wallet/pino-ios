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

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var walletAPIClient = WalletAPIMockClient()

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

	private func getWalletInfo() {
		// Request to get wallet info
		if let walletInfoModel = getWalletInfoFromUserDefaults() {
			walletInfo = WalletInfoViewModel(walletInfoModel: walletInfoModel)
		} else {
			registerWalletsUserDefaults()
		}
	}

	private func getWalletBalance() {
		// Request to get balance
		walletAPIClient.walletBalance().sink { completed in
			switch completed {
			case .finished:
				print("Wallet balance received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { walletBalance in
			self.walletBalance = WalletBalanceViewModel(balanceModel: walletBalance)
		}.store(in: &cancellables)
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
		if let manageAssetsModel = getAssetsFromUserDefaults() {
			manageAssetsList = manageAssetsModel.compactMap { ManageAssetViewModel(assetModel: $0) }
		} else {
			registerAssetsUserDefaults()
		}
	}

	public func saveAssetsInUserDefaults(assets: [AssetModel]) {
		do {
			let encodedAssets = try JSONEncoder().encode(assets)
			UserDefaults.standard.set(encodedAssets, forKey: "assets")
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	public func getAssetsFromUserDefaults() -> [AssetModel]? {
		guard let encodedAssets = UserDefaults.standard.data(forKey: "assets") else { return nil }
		do {
			return try JSONDecoder().decode([AssetModel].self, from: encodedAssets)
		} catch {
			fatalError(error.localizedDescription)
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
				fatalError(error.localizedDescription)
			}
			self.manageAssetsList = assets.assetsList.compactMap { ManageAssetViewModel(assetModel: $0) }
		}.store(in: &cancellables)
	}

	public func getWalletInfoFromUserDefaults() -> WalletInfoModel? {
		guard let encodedWallet = UserDefaults.standard.data(forKey: "selectedWallet") else { return nil }
		do {
			return try JSONDecoder().decode(WalletInfoModel.self, from: encodedWallet)
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	public func registerWalletsUserDefaults() {
		walletAPIClient.walletsList().sink { completed in
			switch completed {
			case .finished:
				print("wallets received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { wallets in
			do {
				let encodedWallets = try JSONEncoder().encode(wallets.walletsList)
				UserDefaults.standard.register(defaults: ["wallets": encodedWallets])
			} catch {
				fatalError(error.localizedDescription)
			}
			guard let firstWallet = wallets.walletsList.first else {
				fatalError("No wallet found in user defaults")
			}
			do {
				let encodedWallet = try JSONEncoder().encode(firstWallet)
				UserDefaults.standard.register(defaults: ["selectedWallet": encodedWallet])
			} catch {
				fatalError(error.localizedDescription)
			}
			self.walletInfo = WalletInfoViewModel(walletInfoModel: firstWallet)
		}.store(in: &cancellables)
	}
}
