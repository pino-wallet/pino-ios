//
//  KeychainWrapperProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

// Every keychain helper system should conform to KeychainWrapper Protocol
// So it can be used in our system
public protocol KeychainWrapper {
	func get(_ key: String) -> String?
	func set(
		_ value: String,
		forKey key: String,
		withAccess access: KeychainSwiftAccessOptions?
	) -> Bool
    
	func delete(_ key: String) -> Bool
}
