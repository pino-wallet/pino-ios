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
}
