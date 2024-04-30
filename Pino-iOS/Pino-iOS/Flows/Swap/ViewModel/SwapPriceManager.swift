//
//  SwapViewModel+Price.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/7/23.
//

import Combine
import Foundation
import PromiseKit

class SwapPriceManager {
	// MARK: - Private Properties

	private let paraSwapAPIClient = ParaSwapAPIClient()
	private let oneInchAPIClient = OneInchAPIClient()
	private let zeroXAPIClient = ZeroXAPIClient()
	private var cancellables = Set<AnyCancellable>()
	private let pinoWalletManager = PinoWalletManager()

	// MARK: - Public Methods

	public func getBestPrice(
		srcToken: SwapTokenViewModel,
		destToken: SwapTokenViewModel,
		swapSide: SwapSide,
		amount: String
	) -> Promise<[SwapPriceResponseProtocol]> {
		let swapInfo = SwapPriceRequestModel(
			srcToken: srcToken.selectedToken.id,
			srcDecimals: srcToken.selectedToken.decimal,
			destToken: destToken.selectedToken.id,
			destDecimals: destToken.selectedToken.decimal,
			amount: amount,
			side: swapSide,
			userAddress: Web3Core.Constants.pinoSwapProxyAddress,
			receiver: pinoWalletManager.currentAccount.eip55Address
		)
		cancelPreviousRequests()
		switch swapSide {
		case .sell:
			return getSellPrices(swapInfo: swapInfo)
		case .buy:
			return getBuyPrices(swapInfo: swapInfo)
		}
	}

	public func getLidoProvidersPrice(swapInfo: SwapPriceRequestModel) -> Promise<[SwapPriceResponseProtocol]> {
		cancelPreviousRequests()
		return Promise<[SwapPriceResponseProtocol]> { seal in
			let paraswapPublisher = paraSwapAPIClient.swapPrice(swapInfo: swapInfo)
				.catch { _ in Just(nil) }

			let zeroXPublisher = zeroXAPIClient.swapPrice(swapInfo: swapInfo)
				.catch { _ in Just(nil) }

			Publishers.Zip(
				paraswapPublisher,
				zeroXPublisher
			)
			.delay(for: 0.5, scheduler: RunLoop.main)
			.sink { completed in
				switch completed {
				case .finished:
					print("Swap quote received successfully")
				case let .failure(error):
					print("Error: getting swap quote: \(error)")
					seal.reject(error)
				}
			} receiveValue: { paraswapResponse, zeroXResponse in
				let allResponses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse]
				let valuableResponses = allResponses.compactMap { $0 }
				seal.fulfill(valuableResponses)
			}.store(in: &cancellables)
		}
	}

	public func getSwapResponseFrom(
		provider: SwapProvider,
		srcToken: AssetViewModel,
		destToken: AssetViewModel,
		swapSide: SwapSide,
		amount: String
	) -> Promise<[SwapPriceResponseProtocol]> {
		let swapInfo = SwapPriceRequestModel(
			srcToken: srcToken.id,
			srcDecimals: srcToken.decimal,
			destToken: destToken.id,
			destDecimals: destToken.decimal,
			amount: amount,
			side: swapSide,
			userAddress: Web3Core.Constants.pinoSwapProxyAddress,
			receiver: pinoWalletManager.currentAccount.eip55Address
		)
		cancelPreviousRequests()
		switch provider {
		case .oneInch:
			return getOneInchPriceResponse(swapInfo: swapInfo)
		case .paraswap:
			return getParaswapPriceResponse(swapInfo: swapInfo)
		case .zeroX:
			return getZeroXPriceResponse(swapInfo: swapInfo)
		}
	}

	public func cancelPreviousRequests() {
		cancellables.removeAll()
	}

	// MARK: - Private Methods

	private func getSellPrices(swapInfo: SwapPriceRequestModel) -> Promise<[SwapPriceResponseProtocol]> {
		Promise<[SwapPriceResponseProtocol]> { seal in
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
			.delay(for: 0.5, scheduler: RunLoop.main)
			.sink { completed in
				switch completed {
				case .finished:
					print("Swap quote received successfully")
				case let .failure(error):
					print("Error: getting swap quote: \(error)")
					seal.reject(error)
				}
			} receiveValue: { paraswapResponse, zeroXResponse, oneInchResponse in
				let allResponses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse, oneInchResponse]
				let valuableResponses = allResponses.compactMap { $0 }
				seal.fulfill(valuableResponses)
			}.store(in: &cancellables)
		}
	}

	private func getBuyPrices(swapInfo: SwapPriceRequestModel) -> Promise<[SwapPriceResponseProtocol]> {
		Promise<[SwapPriceResponseProtocol]> { seal in
			let paraswapPublisher = paraSwapAPIClient.swapPrice(swapInfo: swapInfo)
				.catch { _ in Just(nil) }

			let zeroXPublisher = zeroXAPIClient.swapPrice(swapInfo: swapInfo)
				.catch { _ in Just(nil) }

			Publishers.Zip(
				paraswapPublisher,
				zeroXPublisher
			)
			.delay(for: 0.5, scheduler: RunLoop.main)
			.sink { completed in
				switch completed {
				case .finished:
					print("Swap quote received successfully")
				case let .failure(error):
					print("Error: getting swap quote: \(error)")
					seal.reject(error)
				}
			} receiveValue: { paraswapResponse, zeroXResponse in
				let allResponses: [SwapPriceResponseProtocol?] = [paraswapResponse, zeroXResponse]
				let valuableResponses = allResponses.compactMap { $0 }
				seal.fulfill(valuableResponses)
			}.store(in: &cancellables)
		}
	}

	private func getParaswapPriceResponse(swapInfo: SwapPriceRequestModel) -> Promise<[SwapPriceResponseProtocol]> {
		Promise<[SwapPriceResponseProtocol]> { seal in
			paraSwapAPIClient.swapPrice(swapInfo: swapInfo).catch { _ in Just(nil) }.sink { completed in
				switch completed {
				case .finished:
					print("Swap price received successfully")
				case let .failure(error):
					print("Error: getting paraswap swap quote: \(error)")
					seal.reject(error)
				}
			} receiveValue: { paraswapResponse in
				let allResponses: [SwapPriceResponseProtocol?] = [paraswapResponse]
				let valuableResponses = allResponses.compactMap { $0 }
				if !valuableResponses.isEmpty {
					seal.fulfill(valuableResponses)
				}
			}.store(in: &cancellables)
		}
	}

	private func getOneInchPriceResponse(swapInfo: SwapPriceRequestModel) -> Promise<[SwapPriceResponseProtocol]> {
		Promise<[SwapPriceResponseProtocol]> { seal in
			oneInchAPIClient.swapPrice(swapInfo: swapInfo).catch { _ in Just(nil) }.sink { completed in
				switch completed {
				case .finished:
					print("Swap price received successfully")
				case let .failure(error):
					print("Error: getting one inch swap quote: \(error)")
					seal.reject(error)
				}
			} receiveValue: { oneInchResponse in
				let allResponses: [SwapPriceResponseProtocol?] = [oneInchResponse]
				let valuableResponses = allResponses.compactMap { $0 }
				if !valuableResponses.isEmpty {
					seal.fulfill(valuableResponses)
				}
			}.store(in: &cancellables)
		}
	}

	private func getZeroXPriceResponse(swapInfo: SwapPriceRequestModel) -> Promise<[SwapPriceResponseProtocol]> {
		Promise<[SwapPriceResponseProtocol]> { seal in
			zeroXAPIClient.swapPrice(swapInfo: swapInfo).catch { _ in Just(nil) }.sink { completed in
				switch completed {
				case .finished:
					print("Swap price received successfully")
				case let .failure(error):
					print("Error: getting 0x swap quote: \(error)")
					seal.reject(error)
				}
			} receiveValue: { zeroXResponse in
				let allResponses: [SwapPriceResponseProtocol?] = [zeroXResponse]
				let valuableResponses = allResponses.compactMap { $0 }
				if !valuableResponses.isEmpty {
					seal.fulfill(valuableResponses)
				}
			}.store(in: &cancellables)
		}
	}
}
