//
//  WalletModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

public struct WalletInfoModel: Codable, Equatable {
	// MARK: - Public Properties

	public var id: String
	public var name: String
	public var address: String
	public var profileImage: String
	public var profileColor: String
	public var balance: String
	public var isSelected: Bool

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case address
		case profileImage = "profile_image"
		case profileColor = "profile_color"
		case balance
		case isSelected = "is_selected"
	}

	// MARK: - Public Methods

	public mutating func isSelected(_ isSelected: Bool) {
		self.isSelected = isSelected
	}
}
