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

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var url: URL {
		URL(string: "https://api.1inch.io/v5.2/1")!.appendingPathComponent(path)
	}

	internal var path: String {
		switch self {
		case .quote:
			return "/quote"
        case .swap:
                return "/swap"
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
            case .swap(swapInfo: let swapInfo):
                return .requestParameters(
                    bodyParameters: nil,
                    bodyEncoding: .urlEncoding,
                    urlParameters: swapInfo.oneInchSwapURLParams
                )
        }
    }

	internal var httpMethod: HTTPMethod {
		switch self {
            case .quote,.swap:
			return .get
        }
	}

	internal var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
			"X-API-TOKEN": "token",
		]
	}
}
