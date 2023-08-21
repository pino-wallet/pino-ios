// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ParaSwapSwapResponseModel: Codable {
    let from, to, value, data: String
    let gasPrice, gas: String
    let chainID: Int
    
    enum CodingKeys: String, CodingKey {
        case from, to, value, data, gasPrice, gas
        case chainID = "chainId"
    }
}

extension ParaSwapSwapResponseModel: SwapPriceResponseProtocol {
    var provider: SwapProvider {
        .paraswap
    }
    
    var srcAmount: String {
        value
    }
    
    var destAmount: String {
        ""
    }
    
    var gasFee: String {
        gas
    }
    
    
}
