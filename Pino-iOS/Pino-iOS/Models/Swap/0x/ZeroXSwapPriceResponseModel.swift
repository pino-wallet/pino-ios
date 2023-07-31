// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zeroXPriceResponseModel = try? JSONDecoder().decode(ZeroXPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ZeroXPriceResponseModel
struct ZeroXPriceResponseModel: SwapPriceResponseProtocol {
    let chainId: Int
    let price, grossPrice, estimatedPriceImpact, value: String
    let gasPrice, gas, estimatedGas, protocolFee: String
    let minimumProtocolFee, buyTokenAddress, buyAmount, grossBuyAmount: String
    let sellTokenAddress, sellAmount, grossSellAmount: String
    let sources: [Source]
    let allowanceTarget, sellTokenToEthRate, buyTokenToEthRate: String
    let auxiliaryChainData: AuxiliaryChainData
}

// MARK: - AuxiliaryChainData
struct AuxiliaryChainData: Codable {
}

// MARK: - Source
struct Source: Codable {
    let name, proportion: String
}
