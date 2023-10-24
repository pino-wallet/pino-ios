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
	let priceRoute: Data?
	let provider: SwapProvider

	var editedSrcToken: String {
		if srcToken == Web3Core.Constants.pinoETHID {
			return Web3Core.Constants.wethTokenID
		} else {
			return srcToken
		}
	}

	var editedDestToken: String {
		if destToken == Web3Core.Constants.pinoETHID {
			switch provider {
			case .oneInch, .paraswap:
				return Web3Core.Constants.paraSwapETHID
			case .zeroX:
				return Web3Core.Constants.wethTokenID
			}
		} else {
			return destToken
		}
	}

	// MARK: - Initializers

	init(
		srcToken: String,
		destToken: String,
		amount: String,
		destAmount: String,
		receiver: String,
		userAddress: String,
		slippage: String,
		networkID: Int?,
		srcDecimal: String?,
		destDecimal: String?,
		priceRoute: Data?,
		provider: SwapProvider
	) {
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
		self.provider = provider
	}

	// MARK: - Public Properties

	public var oneInchSwapURLParams: HTTPParameters {
		[
			"src": editedSrcToken,
			"dst": editedDestToken,
			"amount": amount,
			"from": receiver, // this is pino proxy
			"receiver": receiver, // this is user who receives token
			"slippage": slippage,
			"includeProtocols": false,
			"includeTokensInfo": false,
			"disableEstimate": true,
			"allowPartialFill": true,
		]
	}

	public var paraswapReqBody: BodyParamsType {
        guard let priceRoute else { fatalError() }
		let dictionary = try! JSONSerialization.jsonObject(with: priceRoute, options: []) as? HTTPParameters

		let params: HTTPParameters = [
			"srcToken": editedSrcToken,
			"destToken": editedDestToken,
			"srcAmount": amount,
			"destAmount": destAmount,
            "priceRoute": dictionary!["priceRoute"]!,
			"userAddress": userAddress, // this is pino proxy address
			"receiver": receiver, // this is user who receieves token
			"srcDecimals": srcDecimal!,
			"destDecimals": destDecimal!,
		]
		return BodyParamsType.json(params)
	}
}
