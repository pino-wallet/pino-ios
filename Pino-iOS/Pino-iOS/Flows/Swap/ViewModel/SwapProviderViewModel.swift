//
//  SwapProvider.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/4/23.
//

import Foundation

struct SwapProviderViewModel {
	// MARK: - Public Properties

	public var provider: SwapProvider
	public var swapAmount: String
}

extension SwapProviderViewModel {
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
}
