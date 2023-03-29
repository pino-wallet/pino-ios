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
	public var assetsList: [AssetViewModel] = []
	@Published
	public var positionAssetsList: [AssetViewModel]!
	@Published
	public var securityMode = false
	@Published
	public var manageAssetsList: [AssetViewModel]! = []

	public let copyToastMessage = "Copied!"
	public let connectionErrorToastMessage = "No internet connection"
	public let requestFailedErrorToastMessage = "Couldn't refresh home data"
	public let sendButtonTitle = "Send"
	public let receiveButtonTitle = "Receive"
	public let sendButtonImage = "arrow_up"
	public let receiveButtonImage = "arrow_down"

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()

	#warning("Mock client is temporary and must be replaced by API client")
	private var assetsAPIClient = AssetsAPIMockClient()
	private var walletAPIClient = WalletAPIMockClient()
	private var accountingAPIClient = AccountingAPIClient()

	// MARK: - Initializers

	init() {
		getWalletInfo()
		getWalletBalance()
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
				self.manageAssetsList = assets.compactMap { AssetViewModel(assetModel: $0) }
				self.assetsList = self.manageAssetsList.filter { $0.isSelected }
			}.store(in: &cancellables)
	}

	private func getPositionAssetsList() {
		positionAssetsList = []
	}

	public func getWalletInfoFromUserDefaults() -> WalletInfoModel? {
		guard let encodedWallet = UserDefaults.standard.data(forKey: "wallets") else { return nil }
		do {
			let decodedWallets = try JSONDecoder().decode([WalletInfoModel].self, from: encodedWallet)
			return decodedWallets.first(where: { $0.isSelected })
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
			guard let firstWallet = wallets.walletsList.first(where: { $0.isSelected }) else {
				fatalError("No selected wallet found in user defaults")
			}
			self.walletInfo = WalletInfoViewModel(walletInfoModel: firstWallet)
		}.store(in: &cancellables)
	}
}
