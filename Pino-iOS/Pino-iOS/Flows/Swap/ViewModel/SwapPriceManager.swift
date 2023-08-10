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
		cancelPreviousRequests()
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

	public func cancelPreviousRequests() {
		cancellables.removeAll()
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
		)
		.delay(for: 0.8, scheduler: RunLoop.main)
		.sink { completed in
			switch completed {
			case .finished:
				print("Swap price received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { paraswapResponse, zeroXResponse, oneInchResponse in
			let allResponses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse, oneInchResponse]
			let valuableResponses = allResponses.compactMap { $0 }
			if !valuableResponses.isEmpty {
				completion(valuableResponses)
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
		.delay(for: 0.8, scheduler: RunLoop.main)
		.sink { completed in
			switch completed {
			case .finished:
				print("Swap price received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { paraswapResponse, zeroXResponse in
			let allResponses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse]
			let valuableResponses = allResponses.compactMap { $0 }
			if !valuableResponses.isEmpty {
				completion(valuableResponses)
			}
		}.store(in: &cancellables)
	}
}
