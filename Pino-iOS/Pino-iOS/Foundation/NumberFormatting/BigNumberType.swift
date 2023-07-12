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
	// MARK: - Public Properties

	public var number: BigInt
	public var decimal: Int

	// MARK: - Initializers

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

	public init(numberWithDecimal: String) {
		var trimmingNumber = numberWithDecimal
		guard let decimalSeperator = numberWithDecimal.first(where: { $0 == "." || $0 == "," }) else {
			// Passed string has no decimal and is passed to wrong initlizer
			self.number = BigInt(trimmingNumber)!
			self.decimal = 0
			return
		}
		let wholeAndFraction = trimmingNumber.split(separator: decimalSeperator)
		trimmingNumber.remove(at: trimmingNumber.firstIndex(of: decimalSeperator)!)
		self.number = BigInt(trimmingNumber)!
		self.decimal = wholeAndFraction.last!.count
	}

	// MARK: - Public Properties

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
}

// MARK: - Operator Overloading

extension BigNumber {
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
		let (lhsNorm, rhsNorm) = normalize(lhs: lhs, rhs: rhs)
		return lhsNorm < rhsNorm
	}

	public static func <= (lhs: BigNumber, rhs: BigNumber) -> Bool {
		lhs < rhs || lhs == rhs
	}

	public static func > (lhs: BigNumber, rhs: BigNumber) -> Bool {
		!(lhs <= rhs)
	}

	public static func >= (lhs: BigNumber, rhs: BigNumber) -> Bool {
		!(lhs < rhs)
	}

	public static func == (lhs: BigNumber, rhs: BigNumber) -> Bool {
		lhs.number == rhs.number && lhs.decimal == rhs.decimal
	}

	// Normalize two BigNumbers to have the same decimal scale
	private static func normalize(lhs: BigNumber, rhs: BigNumber) -> (BigInt, BigInt) {
		if lhs.decimal == rhs.decimal {
			return (lhs.number, rhs.number)
		} else if lhs.decimal > rhs.decimal {
			let scalingFactor = BigInt(10).power(lhs.decimal - rhs.decimal)
			return (lhs.number, rhs.number * scalingFactor)
		} else { // rhs.decimal > lhs.decimal
			let scalingFactor = BigInt(10).power(rhs.decimal - lhs.decimal)
			return (lhs.number * scalingFactor, rhs.number)
		}
	}
}

extension BigNumber: CustomStringConvertible {
	public var description: String {
		number.description
	}

	public var decimalString: String {
		"\(whole).\(fraction)"
	}

	public var sevenDigitFormat: String {
		formattedAmountOf(type: .sevenDigitsRule)
	}

	public var priceFormat: String {
		formattedAmountOf(type: .priceRule)
	}

	private func formattedAmountOf(type: NumberFormatTypes) -> String {
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
