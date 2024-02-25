//
//  RecentAddressModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import Foundation

struct RecentAddressModel: Codable {
	// MARK: - Public Properties

	public var address: String
	public var userAddress: String
	public var date: Date
	public var ensName: String?
}
