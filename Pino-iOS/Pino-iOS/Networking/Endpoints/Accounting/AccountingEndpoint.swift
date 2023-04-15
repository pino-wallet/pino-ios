//
//  APIEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum AccountingEndpoint: EndpointType {
	#warning("Temporary address to test the api")
	static let accountADD = "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C"

	// MARK: - Cases

	case balances
	case portfolio

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

	internal var endpointParent: String {
		"accounting"
	}

	internal var requiresAuthentication: Bool {
		switch self {
		case .balances:
			return false
		case .portfolio:
			return false
		}
	}

	internal var task: HTTPTask {
		switch self {
		case .balances:
			return .request
		case .portfolio:
			let urlParameters: [String: Any] = ["timeframe": "1h"]
			return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
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
		case .balances:
			return "\(endpointParent)/user/\(AccountingEndpoint.accountADD)/balances"
		case .portfolio:
			return "\(endpointParent)/user/\(AccountingEndpoint.accountADD)/portfolio"
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .balances:
			return .get
		case .portfolio:
			return .get
		}
	}
}
