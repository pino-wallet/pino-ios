//
//  HomepageViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import Combine

class HomepageViewModel {
	// MARK: - Public Properties

	@Published
	public var walletInfo: WalletModel!
	@Published
	public var assetInfo: AssetModel!
	public let copyToastMessage = "Copied!"
	public let sendButtonTitle = "Send"
	public let recieveButtonTitle = "Recieve"
	public let sendButtonImage = "arrow.up"
	public let recieveButtonImage = "arrow.down"

	// MARK: - Initializers

	init() {
		getWalletInfo()
		getAssetsInfo()
	}

	// MARK: - Private Methods

	private func getWalletInfo() {
		// Request to get wallet info
		let walletModel = WalletModel(
			name: "Amir",
			address: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			profileImage: "avocado"
		)
		walletInfo = walletModel
	}

	private func getAssetsInfo() {
		// Request to get assets info
		let assetModel = AssetModel(
			amount: "$12,568,000",
			profitPercentage: "+5.6%",
			profitInDollor: "+$58.67"
		)
		assetInfo = assetModel
	}
}
