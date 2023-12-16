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

	private func setupBindings() {
		$securityMode.sink { [weak self] securityMode in
			guard let self = self else { return }
			self.switchSecurityMode(securityMode)
		}.store(in: &cancellables)

		GlobalVariables.shared.$selectedManageAssetsList.compactMap { $0 }.sink { assets in
			self.getWalletBalance(assets: assets)
			self.selectedAssetsList = assets.filter { $0.isPosition == false }
			self.positionAssetsList = assets.filter { $0.isPosition == true }
			self.switchSecurityMode(self.securityMode)
		}.store(in: &cancellables)
	}
}
