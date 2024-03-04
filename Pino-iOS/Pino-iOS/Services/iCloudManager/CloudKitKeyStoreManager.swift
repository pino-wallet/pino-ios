//
//  CloudKitKeyStoreManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/3/24.
//

import Foundation

struct CloudKitKeyStoreManager {
	// MARK: - Private Properties

	private let store = NSUbiquitousKeyValueStore()
	private let key: String

	// MARK: - Public Init

	public init(key: String) {
		self.key = key
	}

	// MARK: - Public Methods

	public func setValue(_ value: String) {
		store.set(value, forKey: key)
		store.synchronize()
	}

	public func getValue() -> String? {
		if let value = store.string(forKey: key) {
			return value
		} else {
			return nil
		}
	}
}
