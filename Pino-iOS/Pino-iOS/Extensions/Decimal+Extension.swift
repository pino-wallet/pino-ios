//
//  Decimal+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/4/23.
//

import Foundation

extension Decimal {
	/// This function is removes "." in Decimal numbers
	///  Sample : Converts 234234.34343 -> 23423434343
	///  Suitable for writing tests
	/// - Returns: Trimmed Decimal as s String without  "."
	public func withoutDeicmalDot() -> String {
		String(describing: self).replacingOccurrences(of: ".", with: "")
	}

	public var roundedNumber: String {
		let stringFromNumber = "\(self)"
		if let dotIndex = stringFromNumber.range(of: ".")?.upperBound {
			let charactersCount = stringFromNumber.count
			let distancToDot = stringFromNumber.distance(from: stringFromNumber.startIndex, to: dotIndex)
			if charactersCount > (distancToDot + 1) {
				let endIndex = stringFromNumber.index(dotIndex, offsetBy: 2)
				return "\(stringFromNumber[..<endIndex])"
			} else if charactersCount > distancToDot {
				let endIndex = stringFromNumber.index(dotIndex, offsetBy: 1)
				return "\(stringFromNumber[..<endIndex])"
			} else {
				return stringFromNumber
			}
		} else {
			return stringFromNumber
		}
	}
    
    public var wholePart: Int {
        var result = Decimal()
        var mutableSelf = self
        NSDecimalRound(&result, &mutableSelf, 0, self >= 0 ? .down : .up)
        return Int(result.description)!
    }

	public func formattedAmount(type: NumberFormatTypes) -> String {
		var decimalNumber = self
		var roundedDecimal: Decimal = 0
        NSDecimalRound(&roundedDecimal, &decimalNumber, type.formattingDecimal(wholeNumDigits: String(decimalNumber.wholePart).count), .down)
		return roundedDecimal.description
	}

}
