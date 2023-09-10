//
//  Web3Endpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import Foundation

enum Web3Endpoint: EndpointType {
	// MARK: - Cases

	case hashTypeData(eip712ReqModel: EIP712HashRequestModel)

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
		}
	}

	internal var task: HTTPTask {
		switch self {
		case let .hashTypeData(eip712ReqInfo):

			return .requestParameters(
				bodyParameters: eip712ReqInfo.eip712HashReqBody,
				bodyEncoding: .jsonEncoding,
				urlParameters: nil
			)
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .hashTypeData:
			return .post
		}
	}

	internal var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
			"X-API-TOKEN": "token",
		]
	}
}
