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

	enum CodingKeys: String, CodingKey {
		case txHash = "tx_hash"
		case type, detail
		case fromAddress = "from_address"
		case toAddress = "to_address"
		case failed
		case blockNumber = "block_number"
		case blockTime = "block_time"
	}
}

// MARK: - Detail

struct ActivityDetail: Codable {
	let amount: ActivityAmount?
	let recipient, tokenID: String?
	let token0, token1: Token?
	let userID, from: String?
    let to, `protocol`: String?

	enum CodingKeys: String, CodingKey {
		case amount
		case recipient
		case tokenID = "token_id"
		case token0, token1
		case userID = "user_id"
		case from, to, `protocol`
	}
}

// MARK: - Amount

enum ActivityAmount: Codable {
	case integer(Int)
	case string(String)

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let x = try? container.decode(Int.self) {
			self = .integer(x)
			return
		}
		if let x = try? container.decode(String.self) {
			self = .string(x)
			return
		}
		throw DecodingError.typeMismatch(
			ActivityAmount.self,
			DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Amount")
		)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .integer(x):
			try container.encode(x)
		case let .string(x):
			try container.encode(x)
		}
	}
}

// MARK: - Token

struct Token: Codable {
	let amount, tokenID: String

	enum CodingKeys: String, CodingKey {
		case amount
		case tokenID = "token_id"
	}
}

typealias ActivitiesModel = [ActivityModel]
