//
//  ActivityAPIClient.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import Foundation

final class ParaSwapAPIClient: SwapProvidersAPIServices {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<ParaSwapEndpoint>()
    
	func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ParaSwapPriceResponseModel?, APIError> {
        var editedSwapInfo = swapInfo
        editedSwapInfo.provider = .oneInch
        return networkManager.requestData(.swapPrice(swapInfo: editedSwapInfo))
            .map { responseData in
                ParaSwapPriceResponseModel(priceRoute: responseData)
            }.eraseToAnyPublisher()
	}

	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<ParaswapSwapResponseModel?, APIError> {
		networkManager.request(.swapCoin(swapInfo: swapInfo))
	}
}
