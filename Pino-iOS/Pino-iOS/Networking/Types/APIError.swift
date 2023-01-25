//
//  APIError.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

public enum APIError: Error {
	case failedRequest
	case invalidRequest
	case unreachable
	case unknown
	case unauthorized
	case parametersNil
	case encodingFailed
	case missingURL

	public var description: String {
		switch self {
		case .failedRequest:
			return "Sent request is failed."
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
		}
	}
}
