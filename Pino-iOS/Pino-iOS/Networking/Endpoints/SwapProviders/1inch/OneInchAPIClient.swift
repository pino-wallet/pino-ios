//
//  OneInchAPIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Foundation
import Combine

final class OneInchAPIClient: SwapProvidersAPIServices {
    
    // MARK: - Private Properties

    private let networkManager = NetworkManager<OneInchEndpoint>()

    func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<OneInchPriceResponseModel, APIError> {
        networkManager.request(.quote(swapInfo: swapInfo))
    }
}
