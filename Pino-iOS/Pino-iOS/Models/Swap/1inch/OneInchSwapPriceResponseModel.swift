// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let oneInchPriceResponseModel = try? JSONDecoder().decode(OneInchPriceResponseModel.self, from: jsonData)

import Foundation

// MARK: - OneInchPriceResponseModel
struct OneInchPriceResponseModel: SwapPriceResponseProtocol {
    let toAmount: String
    let gas: Int
}
