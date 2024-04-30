//
//  CustomAssetError.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/25/24.
//

import Foundation

public enum CustomAssetValidationError: Error {
	case notValid
	case networkConnection
	case notValidFromServer
	case unavailableNode
	case unknownError
	case alreadyAdded
	case tryAgain

	public var description: String {
		switch self {
		case .notValid:
			return "Invalid address"
		case .networkConnection:
			return "No internet connection"
		case .notValidFromServer:
			return "Invalid asset"
		case .unavailableNode:
			return "Unavailable node"
		case .unknownError:
			return "Unknown error"
		case .alreadyAdded:
			return "Already added"
		case .tryAgain:
			return "Something went wrong. Try again."
		}
	}
}
