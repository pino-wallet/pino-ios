//
//  ZeroXEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/31/23.
//

import Foundation

enum ZeroXEndpoint: EndpointType {
    // MARK: - Cases

    case quote(swapInfo: SwapPriceRequestModel)

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
        URL(string: "https://api.0x.org/swap/v1")!.appendingPathComponent(path)
    }

    internal var path: String {
        switch self {
        case .quote:
            return "/price"
        }
    }

    internal var task: HTTPTask {
        switch self {
        case .quote(let swapInfo):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: swapInfo.ZeroXSwapURLParams)
        }
    }

    internal var httpMethod: HTTPMethod {
        switch self {
        case .quote:
            return .get
        }
    }

    internal var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "0x-api-key": "7cf84073-95c9-4203-8e85-d3b0fc4cddf0",
        ]
    }
}
