// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome

struct OneInchSwapResponseModel: Codable {
	let toAmount: String
	let tx: OneInchResponseTrx

	// MARK: - Tx

	struct OneInchResponseTrx: Codable {
		let from, to, data, value: String
		let gas: Int
		let gasPrice: String
	}
}

extension OneInchSwapResponseModel: SwapPriceResponseProtocol {
	var provider: SwapProvider {
		.oneInch
	}

	var srcAmount: String {
		toAmount
	}

	var destAmount: String {
		""
	}

	var gasFee: String {
		tx.gasPrice
	}
}
