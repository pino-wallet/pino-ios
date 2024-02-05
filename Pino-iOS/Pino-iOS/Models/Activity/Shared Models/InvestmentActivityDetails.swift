//
//  InvestmentActivityDetails.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/9/23.
//

import Foundation

struct InvestmentActivityDetails: Codable {
	let tokens: [ActivityTokenModel]
	let positionId, activityProtocol: String
	let nftId: Int?

	enum CodingKeys: String, CodingKey {
		case tokens
		case positionId = "position_id"
		case activityProtocol = "protocol"
		case nftId = "nft_id"
	}
}
