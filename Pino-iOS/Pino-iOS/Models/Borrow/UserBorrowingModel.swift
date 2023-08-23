// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)
import Foundation

// MARK: - Welcome

struct UserBorrowingModel: Codable {
	let borrowTokens, collateralTokens: [UserBorrowingToken]
	let dex: String
	let healthScore: Double
	let userID: String

	enum CodingKeys: String, CodingKey {
		case borrowTokens = "borrow_tokens"
		case collateralTokens = "collateral_tokens"
		case dex
		case healthScore = "health_score"
		case userID = "user_id"
	}
}

// MARK: - Token

struct UserBorrowingToken: Codable, Equatable {
	let amount, dex, id: String
	let totalDebt: String?
	let userID: String

	enum CodingKeys: String, CodingKey {
		case amount
		case dex
		case id
		case totalDebt = "total_debt"
		case userID = "user_id"
	}
}
