//
//  PrecisionSystem.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/11/23.
//

import Foundation

class PercisionCalculate {
	private static let formatter = NumberFormatter()
	private static let trimDigit = 6

	static func trimmedValueOf(money moneyValue: Double) -> String {
		let moneyNumber = NSNumber(value: moneyValue)
		formatter.numberStyle = .decimal

		let numDigits = String(format: "%.0f", moneyValue).count
		print("\(moneyValue) : \(numDigits)")

		if numDigits < trimDigit {
			formatter.maximumFractionDigits = 0
		}
		if numDigits == trimDigit {
			formatter.maximumFractionDigits = 1
		}
		if numDigits < trimDigit {
			formatter.maximumFractionDigits = 2
		}

		if let trimmedValue = formatter.string(from: moneyNumber) {
			return trimmedValue
		} else {
			fatalError("Failed to trimm the number")
		}
	}

	static func trimmedValueOf(coin: String) -> String {
		" "
	}
}
