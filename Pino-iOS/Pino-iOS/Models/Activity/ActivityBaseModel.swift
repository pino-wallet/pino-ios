//
//  ActivityBaseModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/18/24.
//

import Foundation

struct ActivityBaseModel: ActivityModelProtocol {
	var txHash: String
	var type: String
	var fromAddress: String
	var toAddress: String
	var failed: Bool?
	var blockNumber: Int?
	var blockTime: String
	var gasUsed: String
	var gasPrice: String
	var prev_txHash: String?

	enum CodingKeys: String, CodingKey {
		case txHash = "tx_hash"
		case type
		case fromAddress = "from_address"
		case toAddress = "to_address"
		case failed
		case blockNumber = "block_number"
		case blockTime = "block_time"
		case gasUsed = "gas_used"
		case gasPrice = "gas_price"
	}
}
