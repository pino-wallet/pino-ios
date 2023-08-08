//
//  SwapProvider.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/4/23.
//

import Foundation

struct SwapProviderViewModel {
	// MARK: - Private Properties

	private var providerResponseInfo: SwapPriceResponseProtocol
	private var side: SwapSide

	// MARK: - Public Properties

	public var provider: SwapProvider {
		providerResponseInfo.provider
	}

	public var swapAmount: String {
		switch side {
		case .sell:
			return providerResponseInfo.destAmount
		case .buy:
			return providerResponseInfo.srcAmount
		}
	}

	public var fee: String {
		providerResponseInfo.gasFee
	}

	public var feeInDollar: String {
		providerResponseInfo.gasFee
	}

	// MARK: - Initializers

	init(providerResponseInfo: SwapPriceResponseProtocol, side: SwapSide) {
		self.providerResponseInfo = providerResponseInfo
		self.side = side
	}
}
