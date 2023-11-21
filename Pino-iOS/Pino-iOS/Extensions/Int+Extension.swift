//
//  Int+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/15/23.
//

import Foundation

extension Int {
	public var bigNumber: BigNumber {
		BigNumber(number: description, decimal: 0)
	}

	public var formattedWithCamma: String {
		let numberFormatter = NumberFormatter()
		numberFormatter.groupingSeparator = ","
		numberFormatter.numberStyle = .decimal
		let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
		return formattedNumber!
	}
}
