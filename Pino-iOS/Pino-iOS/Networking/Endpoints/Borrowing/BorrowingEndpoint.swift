//
//  BorrowingEndpoint.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/11/23.
//

import Foundation

enum BorrowingEndpoint: EndpointType {
	// MARK: - Cases

	case getBorrowingDetails(address: String, dex: String)
	case getBorrowableTokens(dex: String)
	case getBorrowableToken(dex: String, tokenID: String)

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
		case let .getBorrowingDetails(address: address, dex: dex):
			return "user/\(address)/borrowings/\(dex)"
		case let .getBorrowableTokens(dex: dex):
			return "listing/borrowings/\(dex)"
		case let .getBorrowableToken(dex: dex, tokenID: tokenID):
			return "listing/borrowings/\(dex)/\(tokenID)"
		}
	}

	internal var task: HTTPTask {
		switch self {
		case .getBorrowingDetails, .getBorrowableTokens, .getBorrowableToken:
			return .request
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .getBorrowingDetails, .getBorrowableTokens, .getBorrowableToken:
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
