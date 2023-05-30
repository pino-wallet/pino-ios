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
	public var walletInfo: AccountInfoViewModel!
	@Published
	public var walletBalance: WalletBalanceViewModel?
	@Published
	public var assetsList: [AssetViewModel]?
	@Published
	public var positionAssetsList: [AssetViewModel]?
	@Published
	public var securityMode = false
	public var tokens: [Detail]?
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
	internal var ctsAPIclient = CTSAPIClient()

	internal let coreDataManager = CoreDataManager()

	var subscriptions = Set<AnyCancellable>()
	let start = Date()

	// MARK: - Initializers

	init(completion: @escaping (HomeNetworkError?) -> Void) {
		checkDefaultAssetsAdded()
		getSelectedAssetsFromCoreData()
		getWalletInfo()
		setupBindings()
		getHomeDataWithTimer(completion: completion)
	}

	// MARK: - Public Methods

	func getHomeDataWithTimer(completion: @escaping (HomeNetworkError?) -> Void) {
		Timer.publish(every: 12.0, on: .main, in: .common)
			.autoconnect()
			.sink { seconds in
				print("Seconds: \(seconds)")
				self.getHomeData(completion: completion)
			}
			.store(in: &subscriptions)
	}

	public func getHomeData(completion: @escaping (HomeNetworkError?) -> Void) {
		internetConnectivity.$isConnected.tryCompactMap { $0 }.sink { _ in
		} receiveValue: { isConnected in
			if isConnected {
				self.getAssetsList { result in
					switch result {
					case .success:
						completion(nil)
					case .failure:
						completion(.requestFailed)
					}
				}
			} else {
				completion(.networkConnection)
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
		}.store(in: &cancellables)

		$assetsList.sink { assets in
			guard let assets else { return }
			self.getWalletBalance(assets: assets)
		}.store(in: &cancellables)
	}
}
