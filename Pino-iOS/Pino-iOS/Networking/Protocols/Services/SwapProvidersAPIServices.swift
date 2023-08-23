//
//  SwapProvidersAPIServices.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/29/23.
//

import Combine
import Foundation

protocol SwapProvidersAPIServices {
	associatedtype PriceResponseModel: SwapPriceResponseProtocol
	associatedtype SwapResponseModel: Codable

	func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<PriceResponseModel?, APIError>
	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<SwapResponseModel?, APIError>
}
