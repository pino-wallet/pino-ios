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
	public var walletInfo: WalletInfoModel!
	@Published
	public var walletBalance: WalletBalanceModel!
	public let copyToastMessage = "Copied!"
	public let sendButtonTitle = "Send"
	public let recieveButtonTitle = "Recieve"
	public let sendButtonImage = "arrow.up"
	public let recieveButtonImage = "arrow.down"

	// MARK: - Initializers

	init() {
		getWalletInfo()
		getWalletBalance()
	}

	// MARK: - Private Methods

	private func getWalletInfo() {
		// Request to get wallet info
		let walletModel = WalletInfoModel(
			name: "Amir",
			address: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			profileImage: "avocado"
		)
		walletInfo = walletModel
	}

	private func getWalletBalance() {
		// Request to get balance
		let balanceModel = WalletBalanceModel(
			balance: "$12,568,000",
			volatilityPercentage: "+5.6%",
			volatilityInDollor: "+$58.67",
			volatilityType: .profit
		)
		walletBalance = balanceModel
	}
}
