//
//  WalletModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Foundation

struct WalletModel: Codable {
	// MARK: Public Properties

	public let walletInfo: WalletInfoModel
	public let walletBalance: WalletBalanceModel

	// MARK: Public Enums

	public enum CodingKeys: String, CodingKey {
		case walletInfo = "wallet_info"
		case walletBalance = "wallet_balance"
	}
}
