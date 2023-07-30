//
//  SwapPriceRequestModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/29/23.
//

import Foundation

struct SwapPriceRequestModel {
    let srcToken: String
    let srcDecimals: Int
    let destToken: String
    let destDecimals: Int
    let amount: String
    let side: SwapSide
    let networkID: Int = 1
    
    enum SwapSide: Encodable {
        case buy
        case sell
    }
    
    public var paraSwapURLParams: HTTPParameters {
        [
            "srcToken": srcToken,
            "srcDecimals": srcDecimals,
            "destToken": destToken,
            "destDecimals": destDecimals,
            "amount": amount,
            "side": "SELL",
            "network": networkID,
        ]
    }
   
}
