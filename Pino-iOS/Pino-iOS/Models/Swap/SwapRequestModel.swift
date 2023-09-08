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
    let destAmount: String
    let receiver: String
	let userAddress: String
	let slippage: String
	let networkID: Int?
	let srcDecimal: String?
	let destDecimal: String?
	let priceRoute: PriceRouteClass?

    init(srcToken: String, destToken: String, amount: String, destAmount: String, receiver: String, userAddress: String, slippage: String, networkID: Int?, srcDecimal: String?, destDecimal: String?, priceRoute: PriceRouteClass?) {
        self.srcToken = srcToken
        self.destToken = destToken
        self.amount = amount
        self.destAmount = destAmount
        self.receiver = receiver
        self.userAddress = userAddress
        self.slippage = slippage
        self.networkID = networkID
        self.srcDecimal = srcDecimal
        self.destDecimal = destDecimal
        self.priceRoute = priceRoute
    }
    
	public var oneInchSwapURLParams: HTTPParameters {
		[
			"src": srcToken,
			"dst": destToken,
			"amount": amount,
			"from": receiver,
			"slippage": slippage,
			"includeProtocols": false,
			"includeTokensInfo": false,
			"disableEstimate": false,
			"allowPartialFill": false,
		]
	}

	public var paraswapReqBody: BodyParamsType {
        
		let jsonEncoder = JSONEncoder()
		let jsonData = try! jsonEncoder.encode(priceRoute)
        let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
		let params: HTTPParameters = [
			"srcToken": srcToken,
			"destToken": destToken,
            "srcAmount": amount,
            "destAmount": destAmount,
            "priceRoute": dictionary!,
			"userAddress": userAddress,
            "receiver": receiver,
			"srcDecimals": srcDecimal!,
			"destDecimals": destDecimal!,
		]
		return BodyParamsType.json(params)
	}
}
