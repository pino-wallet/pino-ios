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
import PromiseKit

class HomepageViewModel {
	// MARK: - Public Properties

	@Published
	public var walletInfo: AccountInfoViewModel!
	@Published
	public var walletBalance: WalletBalanceViewModel?
	@Published
	public var positionAssetsList: [AssetViewModel]?
	@Published
	public var selectedAssetsList: [AssetViewModel]?
	@Published
	public var securityMode = false
	public var positionAssetDetailsList: [PositionAssetModel]?

	public let sendButtonTitle = "Send"
	public let receiveButtonTitle = "Receive"
	public let sendButtonImage = "arrow_up"
	public let receiveButtonImage = "arrow_down"
	public let showBalanceButtonTitle = "Show balance"
	public let showBalanceButtonImage = "eye"

	// MARK: Private Properties

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init() {
		getWalletInfo()
		setupBindings()
	}

	// MARK: - Public Methods

	public func getGasLimits() {
		let web3Client = Web3APIClient()
		web3Client.getGasLimits().sink { completed in
			switch completed {
			case .finished:
				print("Info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { gasLimitsResponse in
			UserDefaultsManager.gasLimits.setValue(value: gasLimitsResponse)
		}.store(in: &cancellables)
	}

	// MARK: - Private Methods

	private func switchSecurityMode(_ isOn: Bool) {
		if let walletBalance {
			walletBalance.switchSecurityMode(isOn)
		}
		if let selectedAssetsList {
			for asset in selectedAssetsList {
				asset.switchSecurityMode(isOn)
			}
		}
		if let positionAssetsList {
			for asset in positionAssetsList {
				asset.switchSecurityMode(isOn)
			}
		}
		selectedAssetsList = selectedAssetsList
		positionAssetsList = positionAssetsList
	}

	private func setupBindings() {
		$securityMode.sink { [weak self] securityMode in
			guard let self = self else { return }
			self.switchSecurityMode(securityMode)
		}.store(in: &cancellables)

		GlobalVariables.shared.$selectedManageAssetsList.sink { assets in
			if let assets {
				self.getWalletBalance(assets: assets)
				self.positionAssetDetailsList = GlobalVariables.shared.positionAssetDetailsList
				self.groupPositionsByProtocol(assets.filter { $0.isPosition == true })
				self.selectedAssetsList = assets.filter { $0.isPosition == false }
				self.switchSecurityMode(self.securityMode)
			} else {
				self.walletBalance = nil
				self.positionAssetsList = nil
				self.selectedAssetsList = nil
			}
		}.store(in: &cancellables)
	}

	private func groupPositionsByProtocol(_ positions: [AssetViewModel]) {
		var positionsProtocolDictionary: [String: String] = [:]
		var groupedAssetsByProtocol: [String: [AssetViewModel]] = [:]

		positionAssetDetailsList?.forEach { positionAsset in
			positionsProtocolDictionary[positionAsset.positionID] = positionAsset.assetProtocol
		}

		positions.forEach { assetViewModel in
			guard let assetProtocol = positionsProtocolDictionary[assetViewModel.id] else {
				// Cases where no matching protocol is found
				let unknownProtocolKey = "Unknown"
				groupedAssetsByProtocol[unknownProtocolKey, default: []].append(assetViewModel)
				return
			}
			// Assuming asset id matches underlying token in position detail
			if var assetsInProtocol = groupedAssetsByProtocol[assetProtocol] {
				assetsInProtocol.append(assetViewModel)
				groupedAssetsByProtocol[assetProtocol] = assetsInProtocol
			} else {
				groupedAssetsByProtocol[assetProtocol] = [assetViewModel]
			}
		}

		positionAssetsList = groupedAssetsByProtocol.sorted { $0.key < $1.key }.flatMap { $0.value }
	}
}
