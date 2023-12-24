//
//  SuggestedAddressesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import Foundation

struct SuggestedAddressesViewModel {
	// MARK: - Public Properties

	public let recentAddressTitle = "Recent address"
	public let myAddressTitle = "My address"

	public var recentAddresses: [RecentAddressModel] {
		let recentAdds = UserDefaults.standard.value(forKey: "recentSentAddresses") as! [String]
		let adds = recentAdds.map { RecentAddressModel(address: $0) }
		return Array(adds.prefix(3))
	}

	public var userWallets: [AccountInfoViewModel] {
		let coreDataManager = CoreDataManager()
		let unselectedWallets = coreDataManager.getAllWalletAccounts().filter { !$0.isSelected }
		return unselectedWallets.compactMap { AccountInfoViewModel(walletAccountInfoModel: $0) }
	}
}
