//
//  CTSEndpoint.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/27/23.
//

import Foundation

enum CTSEndpoint: EndpointType {
	// MARK: - Cases

	case tokens

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var endpointParent: String {
		"cts"
	}

	internal var task: HTTPTask {
		switch self {
		case .tokens:
			return .request
		}
	}

	internal var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
			"X-API-TOKEN": "token",
		]
	}

	internal var url: URL {
		Environment.apiBaseURL.appendingPathComponent(path)
	}

	internal var path: String {
		switch self {
		case .tokens:
			return "\(endpointParent)/tokens"
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .tokens:
			return .get
		}
	}
}
