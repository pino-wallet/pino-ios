//
//  APIEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum APIEndpoint {
	// MARK: - Cases

	case transactions

	// MARK: - Properties

	func request(privateKey: String?) throws -> URLRequest {
		var request = URLRequest(url: url)
		request.addHeaders(headers)
		request.httpMethod = httpMethod.rawValue

		if requiresAuthentication {
			if let privateKey {
				print(privateKey)
				// Add privateKey as a token
			} else {
				throw APIError.unauthorized
			}
		}

		request.httpBody = httpBody

		return request
	}

	private var url: URL {
		Environment.apiBaseURL.appendingPathComponent(path)
	}

	private var path: String {
		switch self {
		case .transactions:
			return "transactions"
		}
	}

	private var requiresAuthentication: Bool {
		switch self {
		case .transactions:
			return true
		}
	}

	private var httpBody: Data? {
		nil
	}

	private var headers: Headers {
		[
			"Content-Type": "application/json",
			"X-API-TOKEN": "token",
		]
	}

	private var httpMethod: HTTPMethod {
		switch self {
		case .transactions:
			return .get
		}
	}
}

typealias Headers = [String: String]
typealias StatusCode = Int


extension URLRequest {
	fileprivate mutating func addHeaders(_ headers: Headers) {
		headers.forEach { header, value in
			addValue(value, forHTTPHeaderField: header)
		}
	}
}
