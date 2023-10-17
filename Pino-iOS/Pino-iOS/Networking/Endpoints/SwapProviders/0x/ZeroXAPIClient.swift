//
//  ZeroXAPIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Combine
import Foundation

final class ZeroXAPIClient: SwapProvidersAPIServices {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<ZeroXEndpoint>()

	func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ZeroXPriceResponseModel?, APIError> {
		var editedSwapInfo = swapInfo
		editedSwapInfo.provider = .zeroX
		return networkManager.request(.quote(swapInfo: editedSwapInfo))
	}

	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<ZeroXPriceResponseModel?, APIError> {
		Just(nil)
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}
}
