//
//  InvestableAssetModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/25/23.
//

import Foundation

struct InvestableAssetsModel: Codable {
	public let apy: Int
	public let id: String
	public let protocolName: String
	public let risk: String
	public let tokens: [InvestableToken]

	enum CodingKeys: String, CodingKey {
		case apy
		case id
		case protocolName = "protocol"
		case risk
		case tokens
	}

	struct InvestableToken: Codable {
		public let investmentId: String
		public let tokenId: String
		public let idx: Int?

		enum CodingKeys: String, CodingKey {
			case investmentId = "investment_id"
			case tokenId = "token_id"
			case idx
		}
	}
}
