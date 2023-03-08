// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let balanceModel = try? JSONDecoder().decode(BalanceModel.self, from: jsonData)

import Foundation

// MARK: - BalanceModelElement

struct BalanceAssetModel: Codable, AssetProtocol {
	let id, hold, investment: String
	let isVerified: Bool
	let detail: Detail?

	enum CodingKeys: String, CodingKey {
		case id
		case hold
		case investment
		case isVerified = "is_verified"
		case detail
	}
}

// MARK: - Detail

struct Detail: Codable {
	let id, symbol, name, logo: String
	let decimals: Int
	let change24H, changePercentage, price: String

	enum CodingKeys: String, CodingKey {
		case id
		case symbol
		case name
		case logo
		case decimals
		case change24H = "change_24h"
		case changePercentage = "change_percentage"
		case price
	}
}

typealias BalanceModel = [BalanceAssetModel]

protocol AssetProtocol {
	var id: String { get }
	var hold: String { get }
	var isVerified: Bool { get }
	var detail: Detail? { get }
}
