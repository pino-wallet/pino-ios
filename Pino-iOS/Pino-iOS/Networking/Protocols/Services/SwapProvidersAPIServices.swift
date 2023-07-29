//
//  SwapProvidersAPIServices.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/29/23.
//

import Foundation
import Combine

protocol SwapProvidersAPIServices {
    
    // ParaSwap Provider
    func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ParaSwapPriceResponseModel, APIError>
    
}
