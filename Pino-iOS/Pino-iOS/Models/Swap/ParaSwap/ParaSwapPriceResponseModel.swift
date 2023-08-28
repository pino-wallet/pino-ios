// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let paraSwapPriceResponseModel = try? JSONDecoder().decode(ParaSwapPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ParaSwapPriceResponseModel

struct ParaSwapPriceResponseModel: SwapPriceResponseProtocol {
	// MARK: - Private Properties

	public let priceRoute: PriceRoute

	// MARK: - Public Properties

	public var provider: SwapProvider {
		.paraswap
	}

	public var srcAmount: String {
		priceRoute.srcAmount
	}

	public var destAmount: String {
		priceRoute.destAmount
	}

	public var gasFee: String {
		"\(priceRoute.partnerFee)"
	}
}

// MARK: - PriceRoute

struct PriceRoute: Codable {
	let blockNumber, network: Int
	let srcToken: String
	let srcDecimals: Int
	let srcAmount, destToken: String
	let destDecimals: Int
	let destAmount, gasCostUSD, gasCost, side: String
	let tokenTransferProxy, contractAddress, contractMethod: String
	let partnerFee: Int
	let srcUSD, destUSD, partner: String
	let maxImpactReached: Bool
	let hmac: String
}
