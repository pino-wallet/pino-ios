//
//  PositionAssets.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/20/24.
//

import Foundation

struct PositionAssetModel: Codable {
	let positionID: String
	let assetProtocol: String
	let underlyingToken: String
	let type: PositionAssetTypeEnum

	enum CodingKeys: String, CodingKey {
		case positionID = "position_id"
		case assetProtocol = "protocol"
		case underlyingToken = "underlying_token"
		case type
	}

	enum PositionAssetTypeEnum: String, Codable {
		case investment = "investment"
		case collateral = "collateral"
	}
}

typealias PositionAssetsModel = [PositionAssetModel]
