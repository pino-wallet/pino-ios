// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zeroXPriceResponseModel = try? JSONDecoder().decode(ZeroXPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ZeroXPriceResponseModel

struct ZeroXPriceResponseModel: SwapPriceResponseProtocol {
	// MARK: - Private Properties

	private let chainId: Int
	private let price, grossPrice, estimatedPriceImpact, value: String
	private let gasPrice, gas, estimatedGas, protocolFee: String
	private let minimumProtocolFee, buyTokenAddress, buyAmount, grossBuyAmount: String
	private let sellTokenAddress, sellAmount, grossSellAmount: String
	private let sources: [Source]
	private let allowanceTarget, sellTokenToEthRate, buyTokenToEthRate: String
	private let auxiliaryChainData: AuxiliaryChainData

	// MARK: - Public Properties

	public var provider: SwapProviderViewModel.SwapProvider {
		.zeroX
	}

	public var tokenAmount: String {
		buyAmount
	}

	public var gasFee: String {
		protocolFee
	}

	public var gasFeeInDollar: String {
		protocolFee
	}
}

// MARK: - AuxiliaryChainData

struct AuxiliaryChainData: Codable {}

// MARK: - Source

struct Source: Codable {
	let name, proportion: String
}
