//
//  Encodable+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/16/23.
//

import Foundation

extension Encodable {
	/// Encode into JSON and return `Data`
	func jsonData() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .iso8601
		return try encoder.encode(self)
	}
}
