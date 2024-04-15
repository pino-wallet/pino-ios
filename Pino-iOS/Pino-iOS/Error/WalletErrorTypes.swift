//
//  WalletErrorTypes.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore

public enum WalletError: LocalizedError, ToastError {
	case mnemonicGenerationFailed
	case walletCreationFailed
	case importAccountFailed
	case accountAlreadyExists
	case accountNotFound
	case accountDeletionFailed
	case accountActivationFailed(Error)
	case unknownError
	case netwrokError

	public var description: String {
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
		case .netwrokError:
			return "Please check your internet connection and try again"
		}
	}

	public var toastMessage: String {
		switch self {
		case .mnemonicGenerationFailed, .walletCreationFailed:
			"Failed to create wallet"
		case .importAccountFailed, .accountActivationFailed, .accountNotFound:
			"Failed to import account"
		case .unknownError:
			"Unknown error happened. Please try again"
		case .netwrokError:
			"Please check your internet connection and try again"
		case .accountAlreadyExists:
			"Account already exists"
		case .accountDeletionFailed:
			"Failed to remove account"
		}
	}
}

public enum WalletValidatorError: LocalizedError, ToastError {
	case privateKeyIsInvalid
	case publicKeyIsInvalid
	case addressIsInvalid
	case mnemonicIsInvalid

	public var description: String {
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

	public var toastMessage: String {
		"Validation Failed"
	}
}

public enum KeyManagementError: LocalizedError, ToastError {
	case mnemonicsStorageFailed
	case privateKeyStorageFailed
	case publicKeyStorageFailed
	case mnemonicsRetrievalFailed
	case privateKeyRetrievalFailed
	case publicKeyRetrievalFailed

	public var description: String {
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

	public var toastMessage: String {
		"Please check keychain settings"
	}
}

public enum WalletOperationError: LocalizedError, ToastError {
	case wallet(WalletError)
	case validator(WalletValidatorError)
	case keyManager(KeyManagementError)
	case unknow(Error)

	public var description: String {
		switch self {
		case let .wallet(walletError):
			return walletError.description
		case let .validator(walletValidatorError):
			return walletValidatorError.description
		case let .keyManager(keyManagementError):
			return keyManagementError.description
		case let .unknow(error):
			return "Uknown Error:\(error)"
		}
	}

	public var toastMessage: String {
		switch self {
		case let .wallet(walletError):
			walletError.toastMessage
		case let .validator(walletValidatorError):
			walletValidatorError.toastMessage
		case let .keyManager(keyManagementError):
			keyManagementError.toastMessage
		case let .unknow(error):
			"Unknown error happened"
		}
	}
}

public enum ImportWalletError: LocalizedError {
	case invalidPrivateKey
	case duplicateAccountName
	case emptyAccountName

	public var btnErrorTxt: String {
		switch self {
		case .invalidPrivateKey:
			"Invalid Private Key"
		case .duplicateAccountName:
			"Duplicate Name"
		case .emptyAccountName:
			"Invalid Name"
		}
	}
}
