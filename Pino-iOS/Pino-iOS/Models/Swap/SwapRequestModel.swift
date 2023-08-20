//
//  SwapRequestModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/20/23.
//

import Foundation

struct SwapRequestModel {
    var srcToken: String
    var destToken: String
    let amount: String
    let receiver: String
    let sender: String
    let slippage: String
    let networkID: Int?
    
    init(srcToken: String, destToken: String, amount: String, receiver: String, sender: String, slippage: String, networkID: Int?) {
        self.srcToken = srcToken
        self.destToken = destToken
        self.amount = amount
        self.receiver = receiver
        self.sender = sender
        self.slippage = slippage
        self.networkID = networkID
    }
    
    public var OneInchSwapURLParams: HTTPParameters {
        [
            "src": srcToken,
            "dst": destToken,
            "amount": amount,
            "from": sender,
            "slippage": slippage,
            "includeProtocols": "false",
            "includeTokensInfo": "false",
            "disableEstimate": "false",
            "allowPartialFill": "false",
        ]
    }
    
    public var paraSwapURLParams: HTTPParameters {
        [
            "srcToken": srcToken,
            "srcDecimals": srcDecimals!,
            "destToken": destToken,
            "destDecimals": destDecimals!,
            "amount": amount,
            "side": side.rawValue,
            "network": networkID!,
        ]
    }
    
    public var ZeroXSwapURLParams: HTTPParameters {
        var params = [
            "sellToken": srcToken,
            "buyToken": destToken,
        ] as HTTPParameters
        if side == .sell {
            params["sellAmount"] = amount
        } else {
            params["buyAmount"] = amount
        }
        return params
    }
}
