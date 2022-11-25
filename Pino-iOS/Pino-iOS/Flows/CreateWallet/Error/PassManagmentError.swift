//
//  PassManagmentError.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/25/22.
//

import Foundation

// Errors related to pass entering for the first time
enum PassSelectionError: Error {}

// Errors related to pass verification and storage
enum PassVerifyError: Error {
	case dontMatch
	case saveFailed
	case unknown
}
