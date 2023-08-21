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
		if swapInfo.srcToken == SwapPriceRequestModel.pinoETHID {
			editedSwapInfo.srcToken = SwapPriceRequestModel.oneInchETHID
		}
		if swapInfo.destToken == SwapPriceRequestModel.pinoETHID {
			editedSwapInfo.destToken = SwapPriceRequestModel.oneInchETHID
		}
		return networkManager.request(.quote(swapInfo: editedSwapInfo))
	}
    
    func swap(swapInfo: SwapRequestModel) -> AnyPublisher<OneInchPriceResponseModel?, APIError> {
        return networkManager.request(.swap(swapInfo: swapInfo))
    }
    
}
