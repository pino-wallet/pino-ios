//
//  InvestEndpoint.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/12/23.
//

import Foundation

enum InvestmentEndpoint: EndpointType {
	// MARK: - Cases

	case investableAssets
	case investment(accountAddress: String)
	case investPortfolio(timeFrame: String, accountAddress: String)
	case investmentPerformance(timeFrame: String, investmentID: String, accountAddress: String)
	case investmentDetail(accountAddress: String, investmentID: String)

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var endpointParent: String {
		"investment"
	}

	internal var task: HTTPTask {
		switch self {
		case .investment, .investableAssets, .investmentDetail:
			return .request
		case let .investPortfolio(timeFrame, _):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
			return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
		case let .investmentPerformance(timeFrame: timeFrame, investmentID: _, accountAddress: _):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
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
		case .investableAssets:
			return "listing/investments"
		case let .investment(accountAddress):
			return "user/\(accountAddress)/investment"
		case let .investPortfolio(_, accountAddress):
			return "user/\(accountAddress)/investment/portfolio"
		case let .investmentPerformance(_, investmentID, accountAddress):
			return "user/\(accountAddress)/investment/portfolio/\(investmentID)"
		case let .investmentDetail(accountAddress, investmentID):
			return "user/\(accountAddress)/investment/\(investmentID)"
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .investment, .investPortfolio, .investmentPerformance, .investmentDetail, .investableAssets:
			return .get
		}
	}
}
