//
//  ActivityEndPoint.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Foundation

enum ParaSwapEndpoint: EndpointType {
	// MARK: - Cases

	case swapPrice(swapInfo: SwapPriceRequestModel)
	case swapCoin(swapInfo: SwapRequestModel)

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		request.addHeaders(headers)
		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var url: URL {
		URL(string: "https://apiv5.paraswap.io")!.appendingPathComponent(path)
	}

	internal var path: String {
		switch self {
		case .swapPrice:
			return "/prices"
		case .swapCoin:
			return "/transactions/1"
		}
	}

	internal var task: HTTPTask {
		switch self {
		case let .swapPrice(swapInfo):
			return .requestParameters(
				bodyParameters: nil,
				bodyEncoding: .urlEncoding,
				urlParameters: swapInfo.paraSwapURLParams
			)
		case let .swapCoin(swapInfo: swapInfo):
			return .requestParameters(
				bodyParameters: swapInfo.paraswapReqBody,
				bodyEncoding: .urlAndJsonEncoding,
				urlParameters: ["ignoreChecks": "true", "ignoreGasEstimate": "true"]
			)
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .swapPrice:
			return .get
		case .swapCoin:
			return .post
		}
	}

	internal var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
		]
	}
}
