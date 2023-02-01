//
//  AssetsEndpoint.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Foundation

enum AssetsEndpoint: EndpointType {
	// MARK: - Cases

	case assets

	// MARK: - Internal Methods

	internal func request(privateKey: String?) throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		if requiresAuthentication {
			if let privateKey {
				print(privateKey)
				// Add privateKey as a token
			} else {
				throw APIError.unauthorized
			}
		}

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var requiresAuthentication: Bool {
		switch self {
		case .assets:
			return false
		}
	}

	internal var task: HTTPTask {
		switch self {
		case .assets:
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
		case .assets:
			return "assets"
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .assets:
			return .get
		}
	}
}
