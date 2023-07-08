//
//  ActivityEndPoint.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Foundation

enum ActivityEndpoint: EndpointType {
	// MARK: - Cases

	case tokenActivities(userAddress: String, tokenAddress: String)
	case allActivities(userAddress: String)

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	var url: URL {
		Environment.apiBaseURL.appendingPathComponent(path)
	}

	var path: String {
		switch self {
		case let .tokenActivities(userAddress: userAddress, tokenAddress: tokenAddress):
			return "user/\(userAddress)/activities/\(tokenAddress)"
		case let .allActivities(userAddress: userAddress):
			return "user/\(userAddress)/activities"
		}
	}

	var task: HTTPTask {
		switch self {
		case .allActivities, .tokenActivities:
			return .request
		}
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .allActivities, .tokenActivities:
			return .get
		}
	}

	var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
			"X-API-TOKEN": "token",
		]
	}
}
