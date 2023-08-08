//
//  SwapViewModel+Price.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/7/23.
//

import Combine
import Foundation

class SwapPriceManager {
	// MARK: - Private Properties

	private let paraSwapAPIClient = ParaSwapAPIClient()
	private let oneInchAPIClient = OneInchAPIClient()
	private let zeroXAPIClient = ZeroXAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

	public func getBestPrice(
		srcToken: SwapTokenViewModel,
		destToken: SwapTokenViewModel,
		swapSide: SwapSide,
		amount: String,
		completion: @escaping (_ responses: [SwapPriceResponseProtocol]) -> Void
	) {
		let swapInfo = SwapPriceRequestModel(
			srcToken: srcToken.selectedToken.id,
			srcDecimals: srcToken.selectedToken.decimal,
			destToken: destToken.selectedToken.id,
			destDecimals: destToken.selectedToken.decimal,
			amount: amount,
			side: swapSide
		)
		switch swapSide {
		case .sell:
			getSellPrices(swapInfo: swapInfo) { responses in
				completion(responses)
			}
		case .buy:
			getBuyPrices(swapInfo: swapInfo) { responses in
				completion(responses)
			}
		}
	}

	// MARK: - Private Methods

	private func getSellPrices(
		swapInfo: SwapPriceRequestModel,
		completion: @escaping ([SwapPriceResponseProtocol]) -> Void
	) {
		Publishers.Zip(
			paraSwapAPIClient.swapPrice(swapInfo: swapInfo),
			zeroXAPIClient.swapPrice(swapInfo: swapInfo)
		).sink { completed in
			switch completed {
			case .finished:
				print("Swap price received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { paraswapResponse, zeroXResponse in
			completion([paraswapResponse, zeroXResponse])
		}.store(in: &cancellables)
	}

	private func getBuyPrices(
		swapInfo: SwapPriceRequestModel,
		completion: @escaping ([SwapPriceResponseProtocol]) -> Void
	) {
		Publishers.Zip(
			paraSwapAPIClient.swapPrice(swapInfo: swapInfo),
			zeroXAPIClient.swapPrice(swapInfo: swapInfo)
		).sink { completed in
			switch completed {
			case .finished:
				print("Swap price received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { paraswapResponse, zeroXResponse in
			completion([paraswapResponse, zeroXResponse])
		}.store(in: &cancellables)
	}
}
