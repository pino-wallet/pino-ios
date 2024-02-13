//
//  BigNumberType.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/6/23.
//

import BigInt
import Foundation
import Web3
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
	public static let minAcceptableAmount = BigNumber(unSignedNumber: 1, decimal: 6)

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

	public init?(numberWithDecimal: String) {
		guard numberWithDecimal != .emptyString else { return nil }
		var trimmingNumber = numberWithDecimal.trimmCurrency
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

	public var bigUInt: BigUInt {
		BigUInt(number)
	}

	public var etherumQuantity: EthereumQuantity {
		.init(quantity: bigUInt)
	}

	public var whole: BigInt {
		number.quotientAndRemainder(dividingBy: BigInt(10).power(decimal)).quotient
	}

	public var fraction: String {
		// fraction is string because in some case the fraction could be like .0123 in this case the 0 before 123
		// would be ignored if the type was not string
		String(decimalString.suffix(decimal))
	}

	public var doubleValue: Double {
		decimalString.doubleValue!
	}

	public var isZero: Bool {
		number.isZero
	}

	public var abs: BigNumber {
		var absNumber = self
		absNumber.number.sign = .plus
		return absNumber
	}

	public static var bigRandomeNumber: BigUInt {
		BigUInt.randomInteger(lessThan: maxUInt256.bigUInt)
	}

	// MARK: - Private Properties

	private var isBiggerThanBillion: Bool {
		let million = BigInt(10).power(9 + decimal)
		if number >= million {
			return true
		} else {
			return false
		}
	}

	private var abbreviatedFormat: String {
		let billion = BigInt(10).power(9 + decimal)
		let trillion = BigInt(10).power(12 + decimal)

		func formatNumber(_ number: BigInt, divisor: BigInt, suffix: String) -> String {
			let wholePart = number / divisor
			let decimalPart = number % divisor

			// Calculate the decimal part for the format
			let decimalDigits = 2 // Number of decimal digits in the abbreviated format
			let decimalDivisor = BigInt(10).power(decimalDigits)
			let formattedDecimalPart = decimalPart * decimalDivisor / divisor

			let decimalString = formattedDecimalPart > 0 ? ".\(formattedDecimalPart)" : ""
			return "\(wholePart)\(decimalString)\(suffix)"
		}

		if number >= trillion {
			return "0"
		} else if number >= billion {
			return formatNumber(number, divisor: billion, suffix: "B")
		} else {
			return number.description
		}
	}
}

// MARK: - Operator Overloading

extension BigNumber {
	static func + (left: BigNumber, right: BigNumber) -> BigNumber {
		let maxDecimal = max(left.decimal, right.decimal)
		let a = left.number * BigInt(10).power(maxDecimal - left.decimal)
		let b = right.number * BigInt(10).power(maxDecimal - right.decimal)
		return BigNumber(number: a + b, decimal: maxDecimal)
	}

	static func - (left: BigNumber, right: BigNumber) -> BigNumber {
		let maxDecimal = max(left.decimal, right.decimal)
		let a = left.number * BigInt(10).power(maxDecimal - left.decimal)
		let b = right.number * BigInt(10).power(maxDecimal - right.decimal)
		return BigNumber(number: a - b, decimal: maxDecimal)
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

		// To increase precision, we may need to adjust the scaling factor based on the magnitude of the numbers involved.
		// A higher scaling factor will result in more preserved decimal places after division.
		let scalingFactorPower = max(left.decimal, right.decimal) +
			10 // Increase the additional scale to improve precision.
		let scalingFactor = BigInt(10).power(scalingFactorPower)

		let scaledLeft = left.number * scalingFactor
		let quotient = scaledLeft / right.number

		// The resultDecimal calculation now includes the additional scaling factor to compensate for the initial scaling.
		let resultDecimal = left.decimal + scalingFactorPower - right.decimal

		// After division, we might have a result with more decimals than desired.
		// Adjusting the result to match the expected decimal places can be done outside this function or considered here if a
		// specific precision is required.

		return BigNumber(number: quotient, decimal: resultDecimal)
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
		let (lhsNorm, rhsNorm) = normalize(lhs: lhs, rhs: rhs)
		return lhsNorm == rhsNorm
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
		bigIntFormat
	}

	public var bigIntFormat: String {
		number.description
	}

	public var decimalString: String {
		Utilities.formatToPrecision(
			number,
			units: .custom(decimal),
			formattingDecimals: 18,
			decimalSeparator: ".",
			fallbackToScientific: false
		)
	}

	public var formattedDecimalString: String {
		// Use formatToPrecision to format the number according to the BigNumber's decimal property
		let rawFormattedString = Utilities.formatToPrecision(
			number,
			units: .custom(decimal),
			formattingDecimals: decimal,
			decimalSeparator: ".",
			fallbackToScientific: false
		)

		// Split the string into whole and fractional parts
		let parts = rawFormattedString.split(separator: ".").map(String.init)

		// If there is no fractional part, return the whole part
		guard parts.count > 1 else {
			return parts[0]
		}

		let wholePart = parts[0]
		let fractionalPart = parts[1]

		// Remove trailing zeros from the fractional part
		var trimmedFractionalPart = fractionalPart
		while trimmedFractionalPart.hasSuffix("0") && !trimmedFractionalPart.isEmpty {
			trimmedFractionalPart.removeLast()
		}

		// If the fractional part becomes empty after trimming zeros, return only the whole part
		if trimmedFractionalPart.isEmpty {
			return wholePart
		} else {
			// Return the formatted string with the non-empty fractional part
			return "\(wholePart).\(trimmedFractionalPart)"
		}
	}

	public var sevenDigitFormat: String {
		let minAmount = BigNumber(unSignedNumber: 1, decimal: 6)
		if self <= minAmount && !isZero {
			return "<\(minAmount.decimalString)"
		} else {
			return formattedAmountOf(type: .sevenDigitsRule)
		}
	}

	public var plainSevenDigitFormat: String {
		formattedAmountOf(type: .sevenDigitsRule)
	}

	public var priceFormat: String {
		var formattedNumber: String!
		formattedNumber = formattedAmountOf(type: .priceRule)
		if isBiggerThanBillion {
			formattedNumber = abbreviatedFormat
		} else {
			formattedNumber = formattedAmountOf(type: .priceRule)
		}
		if isZero {
			return GlobalZeroAmounts.dollars.zeroAmount
		} else if self.abs < BigNumber(number: 1, decimal: 2) {
			return "<" + "0.01".currencyFormatting
		} else {
			return formattedNumber.formattedNumberWithCamma.currencyFormatting
		}
	}

	public var chartPriceFormat: String {
		var formattedNumber: String!
		if isBiggerThanBillion {
			formattedNumber = abbreviatedFormat
		} else {
			formattedNumber = formattedAmountOf(type: .chartPriceRule)
		}
		if isZero {
			return GlobalZeroAmounts.dollars.zeroAmount
		} else if self.abs < BigNumber(number: 1, decimal: 2) {
			return "<" + "0.01".currencyFormatting
		} else {
			return formattedNumber.formattedNumberWithCamma.currencyFormatting
		}
	}

	public var plainPriceFormat: String {
		var formattedNumber: String!
		formattedNumber = formattedAmountOf(type: .priceRule)
		if isZero {
			return "0"
		} else if self.abs < BigNumber(number: 1, decimal: 2) {
			return "<" + "0.01".currencyFormatting
		} else {
			return formattedNumber.formattedNumberWithCamma.currencyFormatting
		}
	}

	public var percentFormat: String {
		var formattedPercent = formattedAmountOf(type: .percentRule)
		if number.sign == .minus {
			formattedPercent = "-\(formattedPercent)"
		}
		return formattedPercent
	}

	private func formattedAmountOf(type: NumberFormatTypes) -> String {
		let numDigits = whole.description.count

		let formattedNumber = Utilities.formatToPrecision(
			number.magnitude,
			units: .custom(decimal),
			formattingDecimals: type.formattingDecimal(wholeNumDigitsCount: numDigits),
			decimalSeparator: ".",
			fallbackToScientific: false
		)
		return formattedNumber
	}
}

// MARK: - BigNumber Constants

extension BigNumber {
	// Max possible number which maxUInt256 accepts
	static var maxUInt256: Self {
		.init(number: "115792089237316195423570985008687907853269984665640564039457584007913129639935", decimal: 0)
	}
}
