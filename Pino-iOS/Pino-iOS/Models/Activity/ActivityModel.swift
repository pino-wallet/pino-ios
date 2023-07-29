// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement

struct ActivityModel: Codable {
	let txHash: String
	let type: String
	let detail: ActivityDetail?
	let fromAddress: String
	let toAddress: String
	let failed: Bool
	let blockNumber: Int
	let blockTime: String
	let gasUsed: String
	let gasPrice: String

	enum CodingKeys: String, CodingKey {
		case txHash = "tx_hash"
		case type, detail
		case fromAddress = "from_address"
		case toAddress = "to_address"
		case failed
		case blockNumber = "block_number"
		case blockTime = "block_time"
		case gasUsed = "gas_used"
		case gasPrice = "gas_price"
	}
}

// MARK: - Detail

struct ActivityDetail: Codable {
	let amount: String?
	let recipient, tokenID: String?
	let fromToken, toToken: Token?
	let userID, from: String?
	let to, activityProtocol: String?

	enum CodingKeys: String, CodingKey {
		case amount
		case recipient
		case tokenID = "token_id"
		case fromToken = "token0"
		case toToken = "token1"
		case userID = "user_id"
		case activityProtocol = "protocol"
		case from, to
	}
}

// MARK: - Token

struct Token: Codable {
	let amount, tokenID: String

	enum CodingKeys: String, CodingKey {
		case amount
		case tokenID = "id"
	}
}

typealias ActivitiesModel = [ActivityModel]
