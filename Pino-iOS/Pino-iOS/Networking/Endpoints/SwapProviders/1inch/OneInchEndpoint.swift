//
//  OneInchEndpoin.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Foundation

enum OneInchEndpoint: EndpointType {
	// MARK: - Cases

	case quote(swapInfo: SwapPriceRequestModel)
	case swap(swapInfo: SwapRequestModel)

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
		Environment.apiBaseURL.appendingPathComponent(path)
	}

	internal var path: String {
		switch self {
		case .quote:
			return "swap/1inch-quote"
		case .swap:
			return "swap/1inch-swap"
		}
	}

	internal var task: HTTPTask {
		switch self {
		case let .quote(swapInfo):
			return .requestParameters(
				bodyParameters: nil,
				bodyEncoding: .urlEncoding,
				urlParameters: swapInfo.OneInchSwapURLParams
			)
		case let .swap(swapInfo: swapInfo):
			return .requestParameters(
				bodyParameters: nil,
				bodyEncoding: .urlEncoding,
				urlParameters: swapInfo.oneInchSwapURLParams
			)
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .quote, .swap:
			return .get
		}
	}

	internal var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
		]
	}
}
