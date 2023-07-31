//
//  SwapProvidersAPIServices.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/29/23.
//

import Foundation
import Combine

protocol SwapProvidersAPIServices {
    
    associatedtype ResponseModel: SwapPriceResponseProtocol

    func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ResponseModel, APIError>
}
