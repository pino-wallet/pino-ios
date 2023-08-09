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
		let paraswapPublisher = paraSwapAPIClient.swapPrice(swapInfo: swapInfo)
			.catch { _ in Just(nil) }

		let zeroXPublisher = zeroXAPIClient.swapPrice(swapInfo: swapInfo)
			.catch { _ in Just(nil) }

		let oneInchPublisher = oneInchAPIClient.swapPrice(swapInfo: swapInfo)
			.catch { _ in Just(nil) }

		Publishers.Zip3(
			paraswapPublisher,
			zeroXPublisher,
			oneInchPublisher
		).sink { completed in
			switch completed {
			case .finished:
				print("Swap price received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { paraswapResponse, zeroXResponse, oneInchResponse in
			let responses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse, oneInchResponse]
			if responses.isEmpty {
				self.getSellPrices(swapInfo: swapInfo, completion: completion)
			} else {
				completion(responses.compactMap { $0 })
			}
		}.store(in: &cancellables)
	}

	private func getBuyPrices(
		swapInfo: SwapPriceRequestModel,
		completion: @escaping ([SwapPriceResponseProtocol]) -> Void
	) {
		let paraswapPublisher = paraSwapAPIClient.swapPrice(swapInfo: swapInfo)
			.catch { _ in Just(nil) }

		let zeroXPublisher = zeroXAPIClient.swapPrice(swapInfo: swapInfo)
			.catch { _ in Just(nil) }

		Publishers.Zip(
			paraswapPublisher,
			zeroXPublisher
		)
		.sink { completed in
			switch completed {
			case .finished:
				print("Swap price received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { paraswapResponse, zeroXResponse in
			let responses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse]
			if responses.isEmpty {
				self.getBuyPrices(swapInfo: swapInfo, completion: completion)
			} else {
				completion(responses.compactMap { $0 })
			}
		}.store(in: &cancellables)
	}
}
