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
	var provider: SwapProvider!
    let walletManager = PinoWalletManager()

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
            case .none:
                fatalError("Swpa Provider was not set")
            }
		} else {
			return destToken
		}
	}

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
			"srcToken": editedSrcToken,
			"srcDecimals": srcDecimals!,
			"destToken": editedDestToken,
			"destDecimals": destDecimals!,
			"amount": amount,
			"side": side.rawValue,
			"network": networkID!,
			"userAddress": Web3Core.Constants.pinoProxyAddress,
            "receiver": walletManager.currentAccount.eip55Address,
		]
	}

	public var OneInchSwapURLParams: HTTPParameters {
		[
			"src": editedSrcToken,
			"dst": editedDestToken,
			"amount": amount,
			"includeProtocols": "false",
			"includeTokensInfo": "false",
			"includeGas": "true",
		]
	}

	public var ZeroXSwapURLParams: HTTPParameters {
		var params = [
			"sellToken": editedSrcToken,
            "buyToken": editedDestToken,
		] as HTTPParameters
		if side == .sell {
			params["sellAmount"] = amount
		} else {
			params["buyAmount"] = amount
		}
		return params
	}
}
