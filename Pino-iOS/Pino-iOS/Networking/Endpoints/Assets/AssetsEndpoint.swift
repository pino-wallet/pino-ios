//
//  AssetsEndpoint.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Foundation

enum AssetsEndpoint: EndpointType {
	// MARK: - Public Properties

	public static let currentETHProvider = URL(string: "https://rpc.ankr.com/eth")

	// MARK: - Cases

	case assets
	case positions
	case coinPortfolio
	case coinHistory
	case getUserPositionAssets(userAddress: String)

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var task: HTTPTask {
		switch self {
		case .assets, .positions, .coinPortfolio, .coinHistory, .getUserPositionAssets:
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
		case .positions:
			return "positions"
		case .coinPortfolio:
			return "coin-info"
		case .coinHistory:
			return "coin-history"
		case let .getUserPositionAssets(userAddress):
			return "user/\(userAddress)/positions"
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .assets, .positions, .coinPortfolio, .coinHistory, .getUserPositionAssets:
			return .get
		}
	}
}
