//
//  HomeError.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

enum HomeNetworkError: Error {
	case networkConnection
	case requestFailed

	var message: String {
		switch self {
		case .networkConnection:
			return "No internet connection"
		case .requestFailed:
			return "Couldn't refresh home data"
		}
	}
}
