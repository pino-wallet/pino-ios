//
//  APIEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum AccountingEndpoint: EndpointType {
	// MARK: - Public Properties

	public static let ethID = "0x0000000000000000000000000000000000000000"

	// MARK: - Cases

	case balances(accountADD: String)
	case portfolio(timeFrame: String, accountADD: String)
	case coinPerformance(timeFrame: String, tokenID: String, accountADD: String)
	case activateAccountWith(address: String)

	// MARK: - Internal Methods

	internal func request(privateKey: String?) throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var endpointParent: String {
		"accounting"
	}

	internal var task: HTTPTask {
		switch self {
		case .balances:
			return .request
		case let .portfolio(timeFrame, _):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
			return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
		case let .coinPerformance(timeFrame: timeFrame, tokenID: _, accountADD: _):
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
		case let .balances(accountADD):
			return "\(endpointParent)/user/\(accountADD)/balances"
		case let .portfolio(_, accountADD):
			return "\(endpointParent)/user/\(accountADD)/portfolio"
		case let .coinPerformance(_, tokenID: tokenID, accountADD: accountADD):
			return "\(endpointParent)/user/\(accountADD)/portfolio/\(tokenID)"
		case let .activateAccountWith(address: address):
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
