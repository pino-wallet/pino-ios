//
//  APIErrorMapper.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

struct APIErrorManager {
	// MARK: - Properties

	let error: APIError

	var message: String {
		switch error {
		case .unreachable:
			return "You need to have a network connection."
		case .unknown, .failedRequest, .invalidRequest:
			return "The list of episodes could not be fetched."
		case .unauthorized:
			return "You are not authorized to access the content"
		}
	}
}
