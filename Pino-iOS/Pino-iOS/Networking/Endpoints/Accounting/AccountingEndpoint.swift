//
//  APIEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum AccountingEndpoint: EndpointType {
	// MARK: - Public Properties

	#warning("Temporary address to test the api")
	static let accountADD = "0x81Ad046aE9a7Ad56092fa7A7F09A04C82064e16C"
	public static let ethID = "0x0000000000000000000000000000000000000000"

	// MARK: - Cases

	case balances
	case portfolio(timeFrame: String)
	case coinPerformance(timeFrame: String, tokenID: String)
    case activateAccountWith(address: String)

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
        case .balances, .portfolio, .coinPerformance, .activateAccountWith:
			return false
		}
	}

	internal var task: HTTPTask {
		switch self {
		case .balances:
			return .request
		case let .portfolio(timeFrame):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
			return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
		case let .coinPerformance(timeFrame: timeFrame, tokenID: _):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
			return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
        case .activateAccountWith:
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
		case .balances:
			return "\(endpointParent)/user/\(AccountingEndpoint.accountADD)/balances"
		case .portfolio:
			return "\(endpointParent)/user/\(AccountingEndpoint.accountADD)/portfolio"
		case let .coinPerformance(timeFrame: _, tokenID: tokenID):
			return "\(endpointParent)/user/\(AccountingEndpoint.accountADD)/portfolio/\(tokenID)"
        case .activateAccountWith(address: let address):
            return "\(endpointParent)/activate/\(address)"
        }
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .balances, .portfolio, .coinPerformance:
			return .get
        case .activateAccountWith:
            return .post
        }
	}
}
