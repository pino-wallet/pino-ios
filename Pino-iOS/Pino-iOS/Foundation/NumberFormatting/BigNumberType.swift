//
//  BigNumberType.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/6/23.
//

import BigInt
import Foundation
import Web3_Utility

/** The BigNumber struct is a custom numerical data type that allows for the representation and manipulation of large
 numbers with high precision. The struct holds a BigInt value for the number and an integer for the decimal places.
 It provides computed properties to access the whole and fractional parts of the number, as well as its decimal
 value.
 Additionally, the BigNumber struct implements arithmetic operators such as addition, subtraction, multiplication,
 and division, taking care of proper scaling and handling edge cases such as division by zero. It also conforms to
 the CustomStringConvertible and Equatable protocols, providing custom string representation and equality comparison
 functionality.
 Sample:
 # Code
 ```Swift
 let a = BigNumber(number: BigInt(2345678965), decimal: 12)
 let b = BigNumber(number: BigInt(23478965), decimal: 4)
 let a + b = BigNumber type -> number = 23478988456789650000 & decimal = 16
 ```
 */
public struct BigNumber {
	var number: BigInt
	var decimal: Int

	public init(number: String, decimal: Int) {
		self.number = BigInt(number)!
		self.decimal = decimal
	}

	public init(number: BigInt, decimal: Int) {
		self.number = number
		self.decimal = decimal
	}

	public init(unSignedNumber: BigUInt, decimal: Int) {
		self.number = BigInt(unSignedNumber)
		self.decimal = decimal
	}

	public init(number: BigNumber, decimal: Int) {
		self.number = number.number
		self.decimal = decimal
	}

	public var whole: BigInt {
		number.quotientAndRemainder(dividingBy: BigInt(10).power(decimal)).quotient
	}

	public var fraction: String {
		// fraction is string because in some case the fraction could be like .0123 in this case the 0 before 123
		// would be ignored if the type was not string
		String(number.description.suffix(decimal))
	}

	public var decimalValue: Decimal {
		Decimal(string: number.description)! * pow(10, -decimal)
	}

	public var doubleValue: Double {
		decimalString.doubleValue!
	}

	public var isZero: Bool {
		number.isZero
	}

	static func + (left: BigNumber, right: BigNumber) -> BigNumber {
		let a = left.number * BigInt(10).power(right.decimal)
		let b = right.number * BigInt(10).power(left.decimal)
		let makhrej = left.decimal + right.decimal
		return BigNumber(number: a + b, decimal: makhrej)
	}

	static func - (left: BigNumber, right: BigNumber) -> BigNumber {
		let a = left.number * BigInt(10).power(right.decimal)
		let b = right.number * BigInt(10).power(left.decimal)
		let makhrej = left.decimal + right.decimal
		return BigNumber(number: a - b, decimal: makhrej)
	}

	static func * (left: BigNumber, right: BigNumber) -> BigNumber {
		BigNumber(number: left.number * right.number, decimal: left.decimal + right.decimal)
	}

	static func / (left: BigNumber, right: BigNumber) -> BigNumber? {
		// Handle divisor equal to zero
		if right.number == 0 {
			print("Error: Division by zero is undefined.")
			return nil
		}

		// Scale the operands to have the same decimal places
		let scaledLeft = left.number * BigInt(10).power(right.decimal)
		let scaledRight = right.number * BigInt(10).power(left.decimal)

		// Perform the division operation and adjust the result
		let quotient = scaledLeft / scaledRight

		return BigNumber(number: quotient, decimal: 0)
	}
}

extension BigNumber: Equatable, Comparable {
	public static func < (lhs: BigNumber, rhs: BigNumber) -> Bool {
		let left = lhs.number.power(rhs.decimal)
		let right = rhs.number.power(lhs.decimal)
		if left < right {
			return true
		} else {
			return false
		}
	}

	public static func > (lhs: BigNumber, rhs: BigNumber) -> Bool {
		let left = lhs.number.power(rhs.decimal)
		let right = rhs.number.power(lhs.decimal)
		if left > right {
			return true
		} else {
			return false
		}
	}

	public static func == (lhs: BigNumber, rhs: BigNumber) -> Bool {
		lhs.number == rhs.number && lhs.decimal == rhs.decimal
	}
}

extension BigNumber: CustomStringConvertible {
	public var description: String {
		number.description
	}

	public var decimalString: String {
		"\(whole).\(fraction)"
	}

	public func formattedAmountOf(type: FormatTypes) -> String {
        
        let numDigits = whole.description.count

		return Utilities.formatToPrecision(
			number.magnitude,
			units: .custom(decimal),
            formattingDecimals: type.formattingDecimal(wholeNumDigits: numDigits),
			decimalSeparator: ".",
			fallbackToScientific: false
		)
	}
}

extension BigNumber {
	public enum FormatTypes {
		case price
        case summarizedPrice
		case hold
        case custome(Int)
        
        public func formattingDecimal(wholeNumDigits: Int) -> Int {
            switch self {
            case .price, .hold:
                return 7 - wholeNumDigits
            case .summarizedPrice:
                if wholeNumDigits >= 2 {
                    return 0
                } else {
                    return 2
                }
            case .custome(let digits):
                return digits
            }
        }
        
	}
}
