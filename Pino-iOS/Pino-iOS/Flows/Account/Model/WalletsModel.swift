//
//  WalletsModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

struct Wallets: Codable {
	// MARK: Public Properties

	public let walletsList: [WalletInfoModel]

	// MARK: Public Enums

	public enum CodingKeys: String, CodingKey {
		case walletsList = "data"
	}
}
