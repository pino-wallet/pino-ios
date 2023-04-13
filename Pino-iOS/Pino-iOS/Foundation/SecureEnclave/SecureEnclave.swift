//
//  SecureEnclave.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/13/23.
//

import Foundation

enum KeyManagmentError: LocalizedError {
    case failedToFetchKey
}

protocol KeyManagmentProtocol {
    var algorithm: SecKeyAlgorithm { get }
    func createPrivateKey(name: String) -> SecKey
    func fetchPrivateKey(name: String) -> SecKey?
}

extension KeyManagmentProtocol {
    var algorithm: SecKeyAlgorithm {
        .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
    }
}

class SecureEnclave: KeyManagmentProtocol {
    
}
