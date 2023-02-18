//
//  StringProtocol+Extension.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

extension String {
	var toArray: [String] {
		var array: [String] = []
		enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
			array.append(
				String(self[range])
			)
		}
		return array
	}

	public func shortenedString(characterCount: Int) -> String {
		"\(prefix(characterCount))...\(suffix(characterCount))"
	}

	public func validateETHContractAddress() -> Bool {
		let ethAddressRegex = "^0x[0-9a-fA-F]{40}$"
		if range(of: ethAddressRegex, options: .regularExpression, range: nil, locale: nil) != nil {
			return true
		} else {
			return false
		}
	}
}
