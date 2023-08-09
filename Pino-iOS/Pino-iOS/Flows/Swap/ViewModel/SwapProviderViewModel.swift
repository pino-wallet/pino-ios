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
	private var destToken: AssetViewModel

	// MARK: - Public Properties

	public var provider: SwapProvider {
		providerResponseInfo.provider
	}

	public var swapAmount: BigNumber {
		switch side {
		case .sell:
			return BigNumber(number: providerResponseInfo.destAmount, decimal: destToken.decimal)
		case .buy:
			return BigNumber(number: providerResponseInfo.srcAmount, decimal: destToken.decimal)
		}
	}

	public var formattedSwapAmount: String {
		swapAmount.sevenDigitFormat
	}

	public var formattedSwapAmountWithSymbol: String {
		formattedSwapAmount.tokenFormatting(token: destToken.symbol)
	}

	public var fee: String {
		providerResponseInfo.gasFee
	}

	public var feeInDollar: String {
		providerResponseInfo.gasFee
	}

	// MARK: - Initializers

	init(providerResponseInfo: SwapPriceResponseProtocol, side: SwapSide, destToken: AssetViewModel) {
		self.providerResponseInfo = providerResponseInfo
		self.side = side
		self.destToken = destToken
	}
}
