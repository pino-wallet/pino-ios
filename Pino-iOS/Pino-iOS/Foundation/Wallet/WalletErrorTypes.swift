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
	case accountActivationFailed(Error)
	case unknownError

	public var errorDescription: String? {
		switch self {
		case .mnemonicGenerationFailed:
			return "Failed to create mnemonics"
		case .walletCreationFailed:
			return "Failed to create wallet"
		case .importAccountFailed:
			return "Failed to import account"
		case .accountAlreadyExists:
			return "Account already exists"
		case .accountNotFound:
			return "Account could not be found"
		case .accountDeletionFailed:
			return "Failed to delete account"
		case .accountActivationFailed:
			return "Failed to activate your account"
		case .unknownError:
			return "Unknown Error"
		}
	}
}

public enum WalletValidatorError: LocalizedError {
	case privateKeyIsInvalid
	case publicKeyIsInvalid
	case addressIsInvalid
	case mnemonicIsInvalid

	public var errorDescription: String? {
		switch self {
		case .privateKeyIsInvalid:
			return "Private Key is invalid"
		case .publicKeyIsInvalid:
			return "Public Key is invalid"
		case .addressIsInvalid:
			return "Address is invalid"
		case .mnemonicIsInvalid:
			return "Mnemonics is invalid"
		}
	}
}

public enum KeyManagementError: LocalizedError {
	case mnemonicsStorageFailed
	case privateKeyStorageFailed
	case publicKeyStorageFailed
	case mnemonicsRetrievalFailed
	case privateKeyRetrievalFailed
	case publicKeyRetrievalFailed

	public var errorDescription: String? {
		switch self {
		case .mnemonicsStorageFailed:
			return "Failed to store mnemonics"
		case .privateKeyStorageFailed:
			return "Failed to store private key"
		case .publicKeyStorageFailed:
			return "Failed to store public key"
		case .mnemonicsRetrievalFailed:
			return "Failed to fetch mnemonics"
		case .privateKeyRetrievalFailed:
			return "Failed to fetch private key"
		case .publicKeyRetrievalFailed:
			return "Failed to fetch public key"
		}
	}
}

public enum WalletOperationError: LocalizedError {
	case wallet(WalletError)
	case validator(WalletValidatorError)
	case keyManager(KeyManagementError)
}
