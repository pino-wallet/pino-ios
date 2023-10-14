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
		var editedSwapInfo = swapInfo
		editedSwapInfo.provider = .oneInch
		return networkManager.request(.quote(swapInfo: editedSwapInfo))
	}

	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<OneInchSwapResponseModel?, APIError> {
		networkManager.request(.swap(swapInfo: swapInfo))
	}
}
