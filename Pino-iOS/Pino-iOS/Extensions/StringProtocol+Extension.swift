//
//  StringProtocol+Extension.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

extension StringProtocol {
	var byWords: [String] {
		var byWords: [String] = []
		enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
			byWords.append(
				String(self[range])
			)
		}
		return byWords
	}
}

extension String {
	public var trimmed: String {
		trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
}
