//
//  Double+Extension.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 4/3/23.
//

import Foundation

extension Double {
	func toString(decimal: Int = 9) -> String {
		let value = decimal < 0 ? 0 : decimal
		var string = String(format: "%.\(value)f", self)

		while string.last == "0" || string.last == "." {
			if string.last == "." { string = String(string.dropLast()); break }
			string = String(string.dropLast())
		}
		return string
	}
}
