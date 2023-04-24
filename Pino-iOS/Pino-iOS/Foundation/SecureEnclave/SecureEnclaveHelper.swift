//
//  KeychainManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/13/23.
//  Based on https://github.com/algrid/keychain-sample

import Combine
import Foundation
import LocalAuthentication

class SecureEnclaveHelper {
	// MARK: - Private Initializer

	private init() {}

	// MARK: - Private Properties

	private static let bitSize = 256
	private static var context: LAContext {
		.init()
	}

	// MARK: - Create and store keys in Keychain

	public static func createPrivateKey(name: String) throws -> SecKey {
		// First check if key already exists
		if let key = keyExists(name: name) {
			return key
		}

		let access = getBioSecAccessControl()
		let tag = name.data(using: .utf8)!
		let attributes: [String: Any] = [
			kSecAttrKeyType as String: kSecAttrKeyTypeEC,
			kSecAttrKeySizeInBits as String: SecureEnclaveHelper.bitSize,
			kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
			kSecPrivateKeyAttrs as String: [
				kSecAttrIsPermanent as String: true,
				kSecAttrApplicationTag as String: tag,
				kSecAttrAccessControl as String: access,
			] as [String: Any],
		]

		var error: Unmanaged<CFError>?
		guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
			throw error!.takeRetainedValue() as Error
		}

		return privateKey
	}

	private static func getBioSecAccessControl() -> SecAccessControl {
		var access: SecAccessControl?
		var error: Unmanaged<CFError>?

		access = SecAccessControlCreateWithFlags(
			nil,
			kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
			[.privateKeyUsage, .userPresence],
			&error
		)
		precondition(access != nil, "SecAccessControlCreateWithFlags failed")
		return access!
	}

	// MARK: - Read key from keychain

    public static func loadKey(name: String, context: LAContext) -> Result<SecKey, KeyManagmentError> {
		let tag = name.data(using: .utf8)!
		var query: [String: Any] = [
			kSecClass as String: kSecClassKey,
			kSecAttrApplicationTag as String: tag,
			kSecAttrKeyType as String: kSecAttrKeyTypeEC,
			kSecReturnRef as String: true,
		]

		query[kSecUseAuthenticationContext as String] = context
		// Prevent system UI from automatically requesting Touc ID/Face ID authentication
		// just in case someone passes here an LAContext instance without
		// a prior evaluateAccessControl call
		query[kSecUseAuthenticationUI as String] = kSecUseAuthenticationUISkip

		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		guard status == errSecSuccess else {
			return .failure(.privateKeyFetchFailed)
		}
		return .success(item as! SecKey)
	}

    public static func keyExists(name: String) -> SecKey? {
		switch loadKey(name: name, context: context) {
		case let .success(key):
			return key
		case .failure:
			return nil
		}
	}

	// MARK: - Delete keys from Keychain

    public static func removeKey(name: String) {
		let tag = name.data(using: .utf8)!
		let query: [String: Any] = [
			kSecClass as String: kSecClassKey,
			kSecAttrApplicationTag as String: tag,
		]

		SecItemDelete(query as CFDictionary)
	}

}
