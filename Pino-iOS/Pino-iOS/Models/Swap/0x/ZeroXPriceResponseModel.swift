// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zeroXPriceResponseModel = try? JSONDecoder().decode(ZeroXPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ZeroXPriceResponseModel

struct ZeroXPriceResponseModel: SwapPriceResponseProtocol {
	// MARK: - Private Properties

	let chainId: Int
	let price, guaranteedPrice, estimatedPriceImpact, to: String
	let data, value, gas, estimatedGas: String
	let gasPrice, protocolFee, minimumProtocolFee, buyTokenAddress: String
	let sellTokenAddress, buyAmount, sellAmount: String
	let allowanceTarget, sellTokenToEthRate, buyTokenToEthRate: String
	let grossPrice, grossBuyAmount, grossSellAmount: String

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
		protocolFee
	}
}
