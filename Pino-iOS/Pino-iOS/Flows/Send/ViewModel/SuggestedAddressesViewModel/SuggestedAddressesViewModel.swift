//
//  SuggestedAddressesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import Foundation

struct SuggestedAddressesViewModel {
	// MARK: - Public Properties

	public let recentAddressTitle = "Recent"
	public let myAddressTitle = "My wallets"

	public var recentAddresses: [RecentAddressModel] {
		let recentAddressHelper = RecentAddressHelper()
		let recentAddressList = recentAddressHelper.getUserRecentAddresses()
		return Array(recentAddressList.prefix(3))
	}

	public var userWallets: [AccountInfoViewModel] {
		let coreDataManager = CoreDataManager()
		let unselectedWallets = coreDataManager.getAllWalletAccounts().filter { !$0.isSelected }
		return unselectedWallets.compactMap { AccountInfoViewModel(walletAccountInfoModel: $0) }
	}
}
