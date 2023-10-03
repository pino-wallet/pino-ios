//
//  OneInchAPIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Combine
import Foundation

final class OneInchAPIClient: SwapProvidersAPIServices {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<OneInchEndpoint>()

	func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<OneInchPriceResponseModel?, APIError> {
		var editedSwapInfo: SwapPriceRequestModel = swapInfo
		if swapInfo.srcToken == Web3Core.Constants.pinoETHID {
			editedSwapInfo.srcToken = Web3Core.Constants.oneInchETHID
		}
		if swapInfo.destToken == Web3Core.Constants.pinoETHID {
			editedSwapInfo.destToken = Web3Core.Constants.oneInchETHID
		}
		return networkManager.request(.quote(swapInfo: editedSwapInfo))
	}

	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<OneInchSwapResponseModel?, APIError> {
		networkManager.request(.swap(swapInfo: swapInfo))
	}
}
