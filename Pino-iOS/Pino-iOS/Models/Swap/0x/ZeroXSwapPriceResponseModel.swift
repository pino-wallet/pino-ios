// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let zeroXPriceResponseModel = try? JSONDecoder().decode(ZeroXPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - ZeroXPriceResponseModel
struct ZeroXPriceResponseModel: SwapPriceResponseProtocol {
    let price, value, gasPrice, gas: String
    let estimatedGas, protocolFee, minimumProtocolFee, buyTokenAddress: String
    let buyAmount, sellTokenAddress, sellAmount: String
    let sources: [Source]
    let estimatedGasTokenRefund, allowanceTarget: String
    let grossPrice, grossBuyAmount, grossSellAmount: String
}


// MARK: - Source
struct Source: Codable {
    let name, proportion: String
}
