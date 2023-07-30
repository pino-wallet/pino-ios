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

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

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
        }
	}

	internal var task: HTTPTask {
		switch self {
        case .swapPrice(let swapInfo):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: swapInfo.paraSwapURLParams)
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
        case .swapPrice:
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
