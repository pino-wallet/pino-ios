//
//  NumberFormatterProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/28/23.
//

import BigInt
import Foundation
import Web3Core

public struct NumberType {
	var number: BigInt
	var decimal: Int

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

	static func + (left: NumberType, right: NumberType) -> NumberType {
		let a = left.number * BigInt(10).power(right.decimal)
		let b = right.number * BigInt(10).power(left.decimal)
		let makhrej = left.decimal + right.decimal
		return NumberType(number: a + b, decimal: makhrej)
	}

	static func - (left: NumberType, right: NumberType) -> NumberType {
		let a = left.number * BigInt(10).power(right.decimal)
		let b = right.number * BigInt(10).power(left.decimal)
		let makhrej = left.decimal + right.decimal
		return NumberType(number: a - b, decimal: makhrej)
	}

	static func * (left: NumberType, right: NumberType) -> NumberType {
		NumberType(number: left.number * right.number, decimal: left.decimal + right.decimal)
	}

	static func / (left: NumberType, right: NumberType) -> NumberType? {
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

		return NumberType(number: quotient, decimal: 0)
	}
}

extension NumberType: CustomStringConvertible {
	public var description: String {
		number.description
	}
}

extension NumberType: Equatable {
	public static func == (lhs: NumberType, rhs: NumberType) -> Bool {
		lhs.number == rhs.number && lhs.decimal == rhs.decimal
	}
}

public protocol NumberFormatterProtocol {
	var value: String { get }
	var decimal: Int { get }
	var formattingDecimal: Int { get }
	var formattedAmount: String { get }
	var bigValue: BigInt { get }
	var doubleValue: Double { get }
	var formattedBigValue: BigInt { get }
	var formattedDoubleValue: Double { get }
}

extension NumberFormatterProtocol {
	// MARK: - Public Properties

	public var formattedAmount: String {
		Utilities.formatToPrecision(
			bigValue,
			units: .custom(decimal),
			formattingDecimals: formattingDecimal,
			decimalSeparator: ".",
			fallbackToScientific: false
		)
	}

	public var bigValue: BigInt {
		BigInt(value)!
	}

	public var doubleValue: Double {
		value.doubleValue!
	}

	public var formattedBigValue: BigInt {
		BigInt(formattedAmount)!
	}

	public var formattedDoubleValue: Double {
		formattedAmount.doubleValue!
	}
}
