//
//  WalletErrorTypes.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

enum WalletError: LocalizedError {
    case mnemonicGenerationFailed
    case walletCreationFailed
    case accountAlreadyExists
    case accountNotFound
    case accountDeletionFailed
}

enum WalletValidatorError: LocalizedError {
    case privateKeyIsInvalid
    case publicKeyIsInvalid
    case addressIsInvalid
    case seedIsInvalid
    case mnemonicIsInvalid
}

enum KeyManagementError: LocalizedError {
    case seedStorageFailed
    case privateKeyStorageFailed
    case publicKeyStorageFailed
}

enum WalletOperationError: LocalizedError {
    case wallet(WalletError)
    case validator(WalletValidatorError)
    case keyManager(KeyManagementError)
}
