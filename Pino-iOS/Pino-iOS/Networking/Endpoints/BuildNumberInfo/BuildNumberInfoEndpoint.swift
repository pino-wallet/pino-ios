//
//  BuildNumberInfoEndpoint.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 3/26/24.
//

import Foundation

enum BuildNumberInfoEndpoint: EndpointType {
    // MARK: - Cases

    case getCurrentAppBuildNumberInfo

    // MARK: - Internal Properties

    internal func request() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        try task.configParams(&request)

        return request
    }

    internal var url: URL {
        Environment.apiBaseURL.appendingPathComponent(path)
    }

    internal var path: String {
        switch self {
        case .getCurrentAppBuildNumberInfo:
            return "build-number/current"
        }
    }

    internal var task: HTTPTask {
        switch self {
        case .getCurrentAppBuildNumberInfo:
            return .request
        }
    }

    internal var httpMethod: HTTPMethod {
        switch self {
        case .getCurrentAppBuildNumberInfo:
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
