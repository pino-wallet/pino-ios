//
//  HomepageViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import Combine
import CoreData
import Foundation
import Hyperconnectivity
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
	public let sendButtonTitle = "Send"
	public let receiveButtonTitle = "Receive"
	public let sendButtonImage = "arrow_up"
	public let receiveButtonImage = "arrow_down"
	public let showBalanceButtonTitle = "Show balance"
	public let showBalanceButtonImage = "eye"

	// MARK: Internal Properties

	internal var internetConnectivity = InternetConnectivity()

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

	public func getHomeData(completion: @escaping (Result<Void, HomeRefreshError>) -> Void) {
		internetConnectivity.$isConnected.sink { isConnected in
			guard let isConnected else { return }
			if isConnected {
				self.getAssetsList { result in
					switch result {
					case let .success(assets):
						self.getManageAsset(assets: assets)
						completion(.success(()))
					case .failure:
						completion(.failure(.requestFailed))
					}
				}
			} else {
				completion(.failure(.networkConnection))
			}
		}.store(in: &cancellables)
	}

	// MARK: Private Methods

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
