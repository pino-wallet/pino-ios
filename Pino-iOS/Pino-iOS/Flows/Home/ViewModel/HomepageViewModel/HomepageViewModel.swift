//
//  HomepageViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import Combine
import CoreData
import Foundation
import Network

class HomepageViewModel {
	// MARK: - Public Properties

	@Published
	public var walletInfo: WalletInfoViewModel!
	@Published
	public var walletBalance: WalletBalanceViewModel?
	@Published
	public var assetsList: [AssetViewModel]?
	@Published
	public var positionAssetsList: [AssetViewModel]?
	@Published
	public var securityMode = false
	@Published
	public var manageAssetsList: [AssetViewModel]?
	public var selectedAssets = [SelectedAsset]()
	@Published
	public var assetsModelList: [AssetProtocol]!

	public let copyToastMessage = "Copied!"
	public let connectionErrorToastMessage = "No internet connection"
	public let requestFailedErrorToastMessage = "Couldn't refresh home data"
	public let sendButtonTitle = "Send"
	public let receiveButtonTitle = "Receive"
	public let sendButtonImage = "arrow_up"
	public let receiveButtonImage = "arrow_down"
	public let showBalanceButtonTitle = "Show balance"
	public let showBalanceButtonImage = "eye"

	// MARK: Internal Properties

	internal var cancellables = Set<AnyCancellable>()

	internal var walletAPIClient = WalletAPIMockClient()
	internal var accountingAPIClient = AccountingAPIClient()

	let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
	let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext

	// MARK: - Initializers

	init() {
		getSelectedAssetsFromCoreData()
		getWalletInfo()
		setupBindings()
	}

	// MARK: - Public Methods

	public func getHomeData(completion: @escaping (HomeRefreshError?) -> Void) {
		checkInternetConnection { [weak self] isConnected in
			if isConnected {
				guard let self else { return }
				self.getAssetsList { assets, error in
					if let assets {
						self.getManageAsset(assets: assets)
						completion(nil)
					} else {
						completion(.requestFailed)
					}
				}
				self.getPositionAssetsList()
			} else {
				completion(.networkConnection)
			}
		}
	}

	// MARK: Private Methods

	private func checkInternetConnection(completion: @escaping (_ isConnected: Bool) -> Void) {
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			if path.status == .satisfied {
				completion(true)
				monitor.cancel()
			} else {
				completion(false)
				monitor.cancel()
			}
		}
		monitor.start(queue: DispatchQueue.main)
	}

	private func switchSecurityMode(_ isOn: Bool) {
		if let walletBalance {
			walletBalance.switchSecurityMode(isOn)
		}
		if let assetsList {
			for asset in assetsList {
				asset.switchSecurityMode(isOn)
			}
		}
		if let positionAssetsList {
			for asset in positionAssetsList {
				asset.switchSecurityMode(isOn)
			}
		}
		assetsList = assetsList
		positionAssetsList = positionAssetsList
	}

	private func setupBindings() {
		$securityMode.sink { [weak self] securityMode in
			guard let self = self else { return }
			self.switchSecurityMode(securityMode)
		}.store(in: &cancellables)

		$manageAssetsList.sink { assets in
			guard let assets else { return }
			self.assetsList = assets.filter { $0.isSelected }
			self.getWalletBalance(assets: assets)
		}.store(in: &cancellables)
	}
}
