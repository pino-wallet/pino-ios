//
//  MockKeychainService.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/13/23.
//

import Foundation
@testable import Pino_iOS

#warning("Temporary file to demostrate network layer")
struct MockKeychainService: KeychainWrapper {
	// MARK: Public Methods

	public func get(_ key: String) -> String? {
		""
	}

	public func set(_ value: String, forKey key: String, withAccess access: Pino_iOS.KeychainSwiftAccessOptions?) -> Bool {
		true
	}

	public func delete(_ key: String) -> Bool {
		true
	}
}
