//
//  APIError.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

public enum APIError: ToastError {
	case networkConnection
	case failedRequest
	case invalidRequest
	case unreachable
	case unknown
	case unauthorized
	case parametersNil
	case encodingFailed
	case missingURL
	case notFound
	case failedWith(statusCode: Int)

	// MARK: Public Properties

	public var description: String {
		switch self {
		case .networkConnection:
			return "No internet connection"
		case .failedRequest:
			return "Sent request is failed."
		case let .failedWith(statusCode):
			return "Sent request is failed with status: \(statusCode)."
		case .invalidRequest:
			return "Sent request is invalid."
		case .unreachable:
			return "Network is unreachable."
		case .unknown:
			return "Unknown issue happened."
		case .unauthorized:
			return "Access is not unauthorized."
		case .parametersNil:
			return "Parameters were nil."
		case .encodingFailed:
			return "Parameter encoding failed."
		case .missingURL:
			return "URL is nil."
		case .notFound:
			return "Not found"
		}
	}

	public var toastMessage: String {
		switch self {
		case .networkConnection:
			return "No internet connection"
		case .failedRequest, .invalidRequest, .unreachable, .unknown, .unauthorized, .parametersNil, .encodingFailed,
		     .missingURL, .notFound, .failedWith:
			return "Failed to fetch data"
		}
	}
}
