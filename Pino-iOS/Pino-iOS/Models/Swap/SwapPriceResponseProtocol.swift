//
//  SwapPriceResponseProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Foundation

protocol SwapPriceResponseProtocol: Codable {
	var provider: SwapProvider { get }
	var srcAmount: String { get }
	var destAmount: String { get }
	var gasFee: String { get }
}

enum SwapProvider {
	case oneInch
	case paraswap
	case zeroX

	public var name: String {
		switch self {
		case .oneInch:
			return "1inch"
		case .paraswap:
			return "Paraswap"
		case .zeroX:
			return "0x"
		}
	}

	public var image: String {
		switch self {
		case .oneInch:
			return "1inch_provider"
		case .paraswap:
			return "paraswap_provider"
		case .zeroX:
			return "0x_provider"
		}
	}

	public var contractAddress: String {
		switch self {
		case .oneInch:
			return "0x1111111254EEB25477B68fb85Ed929f73A960582"
		case .paraswap:
			return "0x216B4B4Ba9F3e719726886d34a177484278Bfcae" // TokenTransferProxy
		case .zeroX:
			return "0xDef1C0ded9bec7F1a1670819833240f027b25EfF"
		}
	}

	public var providerService: any SwapProvidersAPIServices {
		switch self {
		case .oneInch:
			return OneInchAPIClient()
		case .paraswap:
			return ParaSwapAPIClient()
		case .zeroX:
			return ZeroXAPIClient()
		}
	}

	public var slippage: String {
		switch self {
		case .oneInch:
			return "1"
		case .paraswap:
			return "1"
		case .zeroX:
			return "1"
		}
	}
}
