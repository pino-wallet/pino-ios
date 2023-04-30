//
//  WalletErrorTypes.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

public enum WalletError: LocalizedError {
	case mnemonicGenerationFailed
	case walletCreationFailed
	case importAccountFailed
	case accountAlreadyExists
	case accountNotFound
	case accountDeletionFailed
	case unknownError
}

public enum WalletValidatorError: LocalizedError {
	case privateKeyIsInvalid
	case publicKeyIsInvalid
	case addressIsInvalid
	case seedIsInvalid
	case mnemonicIsInvalid
}

public enum KeyManagementError: LocalizedError {
	case seedStorageFailed
	case privateKeyStorageFailed
	case publicKeyStorageFailed
}

public enum WalletOperationError: LocalizedError {
	case wallet(WalletError)
	case validator(WalletValidatorError)
	case keyManager(KeyManagementError)
}
