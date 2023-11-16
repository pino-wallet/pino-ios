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
	case getBorrowableTokenDetails(dex: String, tokenID: String)
	case getCollateralizableTokens(dex: String)
    case getPositionTokenId(underlyingTokenId: String, tokenProtocol: String, positionType: PositionTokenType)

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
		case let .getBorrowableTokenDetails(dex: dex, tokenID: tokenID):
			return "listing/borrowings/\(dex)/\(tokenID)"
		case let .getCollateralizableTokens(dex: dex):
			return "listing/collaterals/\(dex)"
        case let .getPositionTokenId(underlyingTokenId: underlyingTokenId, tokenProtocol: tokenProtocol, positionType: positionType):
            return "indexer/position/\(tokenProtocol)/\(positionType.rawValue)/underlying-token/\(underlyingTokenId)"
		}
	}

	internal var task: HTTPTask {
		switch self {
        case .getBorrowingDetails, .getBorrowableTokens, .getBorrowableTokenDetails, .getCollateralizableTokens, .getPositionTokenId:
			return .request
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
        case .getBorrowingDetails, .getBorrowableTokens, .getBorrowableTokenDetails, .getCollateralizableTokens, .getPositionTokenId:
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
