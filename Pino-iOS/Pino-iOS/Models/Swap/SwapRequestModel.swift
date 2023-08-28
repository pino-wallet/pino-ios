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
	let sender: String
	let slippage: String
	let networkID: Int?
	let srcDecimal: String?
	let destDecimal: String?
	let priceRoute: PriceRoute?

	init(
		srcToken: String,
		destToken: String,
		amount: String,
		sender: String,
		slippage: String,
		networkID: Int?,
		srcDecimal: String?,
		destDecimal: String?,
		priceRoute: PriceRoute?
	) {
		self.srcToken = srcToken
		self.destToken = destToken
		self.amount = amount
		self.sender = sender
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
			"from": sender,
			"slippage": slippage,
			"includeProtocols": "false",
			"includeTokensInfo": "false",
			"disableEstimate": "false",
			"allowPartialFill": "false",
		]
	}

	public var paraswapReqBody: BodyParamsType {
		let jsonEncoder = JSONEncoder()
		let jsonData = try! jsonEncoder.encode(priceRoute)
		let priceRouteJSON = String(data: jsonData, encoding: String.Encoding.utf8)!

		let params: HTTPParameters = [
			"srcToken": srcToken,
			"destToken": destToken,
            "srcAmount": amount,
			"priceRoute": priceRouteJSON,
			"slippage": slippage, // in percent
			"userAddress": sender,
			"srcDecimals": srcDecimal!,
			"destDecimals": destDecimal!,
		]
		return BodyParamsType.json(params)
	}
}
