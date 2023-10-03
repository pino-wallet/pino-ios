//
//  SwapPriceRequestModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/29/23.
//

import Foundation

struct SwapPriceRequestModel {
	var srcToken: String
	let srcDecimals: Int?
	var destToken: String
	let destDecimals: Int?
	let amount: String
	let side: SwapSide
	let networkID: Int?
	let userAddress: String
	let receiver: String

	// Initializer for ParaSwap
	init(
		srcToken: String,
		srcDecimals: Int,
		destToken: String,
		destDecimals: Int,
		amount: String,
		side: SwapSide,
		userAddress: String,
		receiver: String
	) {
		self.srcToken = srcToken
		self.srcDecimals = srcDecimals
		self.destToken = destToken
		self.destDecimals = destDecimals
		self.amount = amount
		self.side = side
		self.networkID = 1
		self.userAddress = amount
		self.receiver = amount
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
			"userAddress": Web3Core.Constants.pinoProxyAddress,
			"receiver": "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C",
		]
	}

	public var OneInchSwapURLParams: HTTPParameters {
		[
			"src": srcToken,
			"dst": destToken,
			"amount": amount,
			"includeProtocols": "false",
			"includeTokensInfo": "false",
			"includeGas": "true",
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
