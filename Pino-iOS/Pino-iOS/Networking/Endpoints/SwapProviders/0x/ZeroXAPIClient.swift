//
//  ZeroXAPIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Foundation
import Combine

final class ZeroXAPIClient: SwapProvidersAPIServices {
    
    // MARK: - Private Properties

    private let networkManager = NetworkManager<ZeroXEndpoint>()

    func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ZeroXPriceResponseModel, APIError> {
        networkManager.request(.quote(swapInfo: swapInfo))
    }
}
