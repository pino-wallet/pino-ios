//
//  PassManagmentError.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/25/22.
//

import Foundation

// Errors related to pass entering for the first time
enum PassSelectionError: Error {
	case emptySelectedPasscode
}

// Errors related to pass verification and storage
enum PassVerifyError: Error {
	case dontMatch
	case saveFailed
	case emptyPasscode
	case unknown
}

// Errors related to unlock app with passcode and face id
enum UnlockAppError: Error {
	case dontMatch
	case getPasswordFailed
	case emptyPasscode
}
