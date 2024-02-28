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

	case cts
	case balances(accountADD: String)
	case portfolio(timeFrame: String, accountADD: String, tokensId: [String])
	case coinPerformance(timeFrame: String, tokenID: String, accountADD: String)
	case activateAccount(activateReqModel: AccountActivationRequestModel)
	case activeAddresses(addresses: [String])
	case activateAccountWithInviteCode(deciveID: String, inviteCode: String)
	case tokenAllTime(accountADD: String, tokenID: String)

	// MARK: - Internal Methods

	internal func request() throws -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		request.addHeaders(headers)

		try task.configParams(&request)

		return request
	}

	// MARK: - Internal Properties

	internal var endpointParent: String {
		"accounting"
	}

	internal var task: HTTPTask {
		switch self {
		case .cts, .balances, .activateAccountWithInviteCode, .tokenAllTime:
			return .request
		case let .portfolio(timeFrame, _, tokensId):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
			let bodyParameters: HTTPParameters = ["tokens": tokensId]
			return .requestParameters(
				bodyParameters: .json(bodyParameters),
				bodyEncoding: .urlAndJsonEncoding,
				urlParameters: urlParameters
			)
		case let .coinPerformance(timeFrame: timeFrame, tokenID: _, accountADD: _):
			let urlParameters: [String: Any] = ["timeframe": timeFrame]
			return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: urlParameters)
		case let .activateAccount(accountActivationReq):
			return .requestParameters(
				bodyParameters: accountActivationReq.reqBody,
				bodyEncoding: .jsonEncoding,
				urlParameters: nil
			)
		case let .activeAddresses(addresses):
			return .requestParameters(
				bodyParameters: .object(addresses),
				bodyEncoding: .jsonEncoding,
				urlParameters: nil
			)
		}
	}

	internal var headers: HTTPHeaders {
		[
			"Content-Type": "application/json",
		]
	}

	internal var url: URL {
		Environment.apiBaseURL.appendingPathComponent(path)
	}

	internal var path: String {
		switch self {
		case .cts:
			return "cts/tokens"
		case let .balances(accountADD):
			return "user/\(accountADD)/balances"
		case let .portfolio(_, accountADD, _):
			return "user/\(accountADD)/portfolio"
		case let .coinPerformance(_, tokenID: tokenID, accountADD: accountADD):
			return "user/\(accountADD)/portfolio/\(tokenID)"
		case let .activateAccount(activateReqModel):
			return "\(endpointParent)/activate-sig"
		case .activeAddresses:
			return "\(endpointParent)/active-addresses"
		case let .activateAccountWithInviteCode(deciveID: deviceID, inviteCode: inviteCode):
			return "\(endpointParent)/activate-device/\(deviceID)/\(inviteCode)"
		case let .tokenAllTime(accountADD: accountADD, tokenID: tokenID):
			return "user/\(accountADD)/balance/\(tokenID)/all-time"
		}
	}

	internal var httpMethod: HTTPMethod {
		switch self {
		case .cts, .balances, .coinPerformance, .tokenAllTime:
			return .get
		case .activateAccount, .activeAddresses, .activateAccountWithInviteCode, .portfolio:
			return .post
		}
	}
}

struct TokensID {}
