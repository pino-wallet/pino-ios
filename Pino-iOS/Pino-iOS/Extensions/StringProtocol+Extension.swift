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

	static func minimizeText(text: String, textCount: Int) -> String {
		let firstIndex = text.index(text.startIndex, offsetBy: 4)
		let endIndex = text.index(text.endIndex, offsetBy: -4)

		return "\(text[..<firstIndex])...\(text[endIndex...])"
	}
}
