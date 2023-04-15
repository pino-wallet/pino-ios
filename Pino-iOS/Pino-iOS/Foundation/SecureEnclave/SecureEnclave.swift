//
//  SecureEnclave.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/13/23.
//

import Foundation
import LocalAuthentication

enum KeyManagmentError: LocalizedError {
	case privateKeyFetchFailed
	case publicKeyFetchFailed
	case keyExists
	case algorithmNotSupported
	case encryptionFailed
	case decryptionFailed
}

public protocol KeyManagmentProtocol {
	func encrypt(plainData: Data, withPublicKeyLabel label: String) -> Data
	func decrypt(cipherData: Data, withPublicKeyLabel label: String) throws -> Data
}

class SecureEnclave: KeyManagmentProtocol {
	// MARK: - Private Properties

	private var algorithm: SecKeyAlgorithm {
		.eciesEncryptionCofactorVariableIVX963SHA256AESGCM
	}

	// MARK: - Public Methods

	public func encrypt(plainData: Data, withPublicKeyLabel label: String) -> Data {
		do {
			// 1: Create private key (If private key exists it will be returned else created)
			let privateKey = try KeychainManager.createPrivateKey(name: label)

			// 2: Generate public key from our private key
			guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
				fatalError(KeyManagmentError.publicKeyFetchFailed.localizedDescription)
			}

			// 3: Check if encryption algorithm is supported (Supported iOS 10.0+)
			guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
				fatalError(KeyManagmentError.algorithmNotSupported.localizedDescription)
			}

			// 4: Start Encrypting plain data
			var error: Unmanaged<CFError>?
			let cipherTextData = SecKeyCreateEncryptedData(
				publicKey,
				algorithm,
				plainData as CFData,
				&error
			) as Data?
			guard let cipherData = cipherTextData else {
				fatalError(KeyManagmentError.encryptionFailed.localizedDescription)
			}

			return cipherData

		} catch {
			fatalError(error.localizedDescription)
		}
	}

	public func decrypt(cipherData: Data, withPublicKeyLabel label: String) throws -> Data {
		// 1: Load private key
		#warning("context should be analyzed more")
		let fetchedPrivateKey = KeychainManager.loadKey(name: label, context: LAContext())
		var privateKey: SecKey!

		switch fetchedPrivateKey {
		case let .success(key):
			privateKey = key
		case let .failure(error):
			fatalError(error.localizedDescription)
		}

		// 2: Check if encryption algorithm is supported (Supported iOS 10.0+)
		guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
			fatalError(KeyManagmentError.algorithmNotSupported.localizedDescription)
		}

		var error: Unmanaged<CFError>?
		let clearTextData = SecKeyCreateDecryptedData(
			privateKey,
			algorithm,
			cipherData as CFData,
			&error
		) as Data?
		guard let decryptedData = clearTextData else {
			fatalError(KeyManagmentError.decryptionFailed.localizedDescription)
		}
		return decryptedData
	}
}
