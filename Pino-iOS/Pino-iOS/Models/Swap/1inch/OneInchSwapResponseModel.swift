// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct OneInchSwapResponseModel: Codable {
	public let toAmount: String
	public let tx: OneInchResponseTrx

	// MARK: - Tx

	public struct OneInchResponseTrx: Codable {
		let from, to, data, value: String
		let gas: Int
		let gasPrice: String
	}
}
