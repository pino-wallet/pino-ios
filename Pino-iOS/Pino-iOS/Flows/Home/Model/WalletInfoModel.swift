//
//  WalletModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

public struct WalletInfoModel: Codable {
	// MARK: - Public Properties

	public var name: String
	public var address: String
	public var profileImage: String
	public var profileColor: String

	enum CodingKeys: String, CodingKey {
		case name
		case address
		case profileImage = "profile_image"
		case profileColor = "profile_color"
	}
}
