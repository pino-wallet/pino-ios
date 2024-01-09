// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zeroXPriceResponseModel = try? JSONDecoder().decode(ZeroXPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ZeroXPriceResponseModel

struct ZeroXPriceResponseModel: SwapPriceResponseProtocol {
	// MARK: - Private Properties

	let to, data, value, gasPrice: String
	let gas, estimatedGas, buyAmount, sellAmount: String

	// MARK: - Public Properties

	public var provider: SwapProvider {
		.zeroX
	}

	public var srcAmount: String {
		sellAmount
	}

	public var destAmount: String {
		buyAmount
	}

	public var gasFee: String {
		gas
	}
}

extension ZeroXPriceResponseModel: SwapCoinResponseProtocol {}
