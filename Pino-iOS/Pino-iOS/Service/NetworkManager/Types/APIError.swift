//
//  APIError.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum APIError: Error {
	case failedRequest
	case invalidRequest
	case unreachable
	case unknown
	case unauthorized
}
