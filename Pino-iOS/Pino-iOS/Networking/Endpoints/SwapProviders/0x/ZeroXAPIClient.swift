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

	func swapPrice(swapInfo: SwapPriceRequestModel) -> AnyPublisher<ZeroXPriceResponseModel, APIError> {
		var editedSwapInfo: SwapPriceRequestModel = swapInfo
		if swapInfo.srcToken == SwapPriceRequestModel.pinoETHID {
			editedSwapInfo.srcToken = SwapPriceRequestModel.zeroXETHID
		}
        if swapInfo.destToken == SwapPriceRequestModel.pinoETHID {
            editedSwapInfo.destToken = SwapPriceRequestModel.zeroXETHID
        }
		return networkManager.request(.quote(swapInfo: editedSwapInfo))
	}
}
