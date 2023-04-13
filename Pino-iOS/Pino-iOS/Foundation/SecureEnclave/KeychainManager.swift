//
//  KeychainManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/13/23.
//  Based on https://github.com/algrid/keychain-sample

import Foundation
import LocalAuthentication
import Combine

class KeychainManager {
    
    // MARK: - Private Initializer

    private init() {}
    
    // MARK: - Private Properties

    private static let bitSize:Int = 256
    
    // MARK: - Create and store keys in Keychain
    
    static func createPrivateKey(name: String) throws -> SecKey {
        removeKey(name: name)

        let access = getBioSecAccessControl()
        let tag = name.data(using: .utf8)!
        let attributes: [String: Any] = [
            kSecAttrKeyType as String           : kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String     : KeychainManager.bitSize,
            kSecAttrTokenID as String           : kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String : [
                kSecAttrIsPermanent as String       : true,
                kSecAttrApplicationTag as String    : tag,
                kSecAttrAccessControl as String     : access
            ] as [String : Any]
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
        
        access = SecAccessControlCreateWithFlags(nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence,
            &error)
        precondition(access != nil, "SecAccessControlCreateWithFlags failed")
        return access!
    }
    
    // MARK: - Read key from keychain
    
    static func loadKey(name: String, context: LAContext) -> Result<SecKey, KeyManagmentError> {
        let tag = name.data(using: .utf8)!
        var query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : tag,
            kSecAttrKeyType as String           : kSecAttrKeyTypeEC,
            kSecReturnRef as String             : true
        ]
        
        query[kSecUseAuthenticationContext as String] = context
        // Prevent system UI from automatically requesting Touc ID/Face ID authentication
        // just in case someone passes here an LAContext instance without
        // a prior evaluateAccessControl call
        query[kSecUseAuthenticationUI as String] = kSecUseAuthenticationUISkip
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return .failure(.failedToFetchKey)
        }
        return .success((item as! SecKey))
    }
    
    // MARK: - Delete keys from Keychain
    
    static func removeKey(name: String) {
        let tag = name.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : tag
        ]

        SecItemDelete(query as CFDictionary)
    }
    
    static func remove(key: String) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key]
        
        SecItemDelete(query as CFDictionary)
    }
    
}
