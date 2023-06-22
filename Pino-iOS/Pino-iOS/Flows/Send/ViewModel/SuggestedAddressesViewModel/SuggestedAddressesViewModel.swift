//
//  SuggestedAddressesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

struct SuggestedAddressesViewModel {
	// MARK: - Public Properties

	public let recentAddressTitle = "Recent address"
	public let myAddressTitle = "My address"
	#warning("this is for testing")
	public var recentAddresses: [RecentAddressModel] = [
		RecentAddressModel(address: "0x3a9aa54dCB22b40a070B1D8AD96dcF78f1Af489D"),
		RecentAddressModel(address: "0x3a9aa54dCB22b40a070B1D8AD96dcF78f1Af489D"),
		RecentAddressModel(address: "0x3a9aa54dCB22b40a070B1D8AD96dcF78f1Af489D"),
	]
    
    public var userWallets: [AccountInfoViewModel] {
        let coreDataManager = CoreDataManager()
        let unselectedWallets = coreDataManager.getAllWalletAccounts().filter { !$0.isSelected }
        return unselectedWallets.compactMap { AccountInfoViewModel(walletAccountInfoModel: $0) }
    }

}
