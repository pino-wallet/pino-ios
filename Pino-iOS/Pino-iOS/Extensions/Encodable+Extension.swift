//
//  Encodable+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/16/23.
//

import Foundation

extension Encodable {
	// MARK: Public Methods

	/// Encode into JSON and return `Data`
	public func jsonData() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .iso8601
		return try encoder.encode(self)
	}
}
