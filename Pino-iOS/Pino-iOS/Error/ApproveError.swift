//
//  ApproveError.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/31/24.
//

import Foundation

enum ApproveError: Error {
	case networkConnection
	case failedRequest

	public var toastMessage: String {
		switch self {
		case .networkConnection:
			return "No internet connection"
		case .failedRequest:
			return "Failed to fetch data"
		}
	}
}

enum ApproveSpeedupError: Error {
	case insufficientBalance
	case somethingWrong
	case transactionExist

	public var description: String {
		switch self {
		case .insufficientBalance:
			return "Insufficient balance"
		case .transactionExist:
			return "Your transaction has already been confirmed"
		case .somethingWrong:
			return "Something went wrong, please try again"
		}
	}
}
