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

	// MARK: Private Methods

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

	private func setAssetValues(assets: [AssetViewModel]) {
		getWalletBalance(assets: assets)
		selectedAssetsList = assets.filter { $0.isPosition == false }
		positionAssetsList = assets.filter { $0.isPosition == true }
		switchSecurityMode(securityMode)
	}

	private func destroyValues() {
		walletBalance = nil
		positionAssetsList = nil
		selectedAssetsList = nil
	}

	private func setupBindings() {
		$securityMode.sink { [weak self] securityMode in
			guard let self = self else { return }
			self.switchSecurityMode(securityMode)
		}.store(in: &cancellables)

		GlobalVariables.shared.$selectedManageAssetsList.sink { assets in
			if let assets {
				self.getWalletBalance(assets: assets)
				self.positionAssetsList = assets.filter { $0.isPosition == true }
				self.selectedAssetsList = assets.filter { $0.isPosition == false }
				self.switchSecurityMode(self.securityMode)
				self.positionAssetDetailsList = GlobalVariables.shared.positionAssetDetailsList
			} else {
				self.walletBalance = nil
				self.positionAssetsList = nil
				self.selectedAssetsList = nil
			}
		}.store(in: &cancellables)
	}
}
