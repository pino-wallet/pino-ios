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

    func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ParaSwapPriceResponseModel, APIError> {
        networkManager.request(.swapPrice(swapInfo: swapInfo))
    }
}
