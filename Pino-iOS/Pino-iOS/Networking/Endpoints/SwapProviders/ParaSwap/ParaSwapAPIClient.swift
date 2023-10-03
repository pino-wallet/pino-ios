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
		var editedSwapInfo: SwapPriceRequestModel = swapInfo
		if swapInfo.srcToken == Web3Core.Constants.pinoETHID {
			editedSwapInfo.srcToken = Web3Core.Constants.paraSwapETHID
		}
		if swapInfo.destToken == Web3Core.Constants.pinoETHID {
			editedSwapInfo.destToken = Web3Core.Constants.paraSwapETHID
		}
		return networkManager.request(.swapPrice(swapInfo: editedSwapInfo))
	}

	func swap(swapInfo: SwapRequestModel) -> AnyPublisher<ParaswapSwapResponseModel?, APIError> {
		networkManager.request(.swapCoin(swapInfo: swapInfo))
	}
}
