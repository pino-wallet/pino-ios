//
//  SwapProvidersAPIServices.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/29/23.
//

import Combine
import Foundation

protocol SwapProvidersAPIServices {
    associatedtype ResponseModel: SwapPriceResponseProtocol

    func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ResponseModel?, APIError>
	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<ResponseModel?, APIError>
}
