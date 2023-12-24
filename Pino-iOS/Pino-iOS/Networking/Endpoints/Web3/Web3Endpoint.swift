//
//  Web3Endpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import Foundation

enum Web3Endpoint: EndpointType {
	// MARK: - Cases

	case hashTypeData(eip712ReqModel: BodyParamsType)
	case positionID(tokenAdd: String, positionType: IndexerPositionType, protocolName: String)
	case ehtGasInfo
	case gasLimits

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var url: URL {
		Environment.apiBaseURL.appendingPathComponent(path)
	}

	internal var path: String {
		switch self {
		case .hashTypeData:
			return "web3/hash-typed-data"
		case let .positionID(tokenAdd, positionType, protocolName):
			return "indexer/position/\(protocolName)/\(positionType.rawValue)/underlying-token/\(tokenAdd)"
		case .ehtGasInfo:
			return "web3/network-fee"
		case .gasLimits:
			return "listing/gas-limits"
		}
	}

	internal var task: HTTPTask {
		switch self {
		case let .hashTypeData(eip712ReqInfo):
			return .requestParameters(
				bodyParameters: eip712ReqInfo,
				bodyEncoding: .jsonEncoding,
				urlParameters: nil
			)
		case .positionID, .ehtGasInfo, .gasLimits:
			return .request
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .hashTypeData:
			return .post
		case .positionID, .ehtGasInfo, .gasLimits:
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

enum IndexerPositionType: String {
	case investment
	case debt
}
