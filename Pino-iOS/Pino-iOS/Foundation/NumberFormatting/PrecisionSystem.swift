//
//  PrecisionSystem.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/11/23.
//

import BigInt
import Foundation
import Web3Core

class NumberPercisionFormatter {
	// MARK: - Private Properties

	private static var formatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.decimalSeparator = "."
		formatter.groupingSeparator = ""
		return formatter
	}

	private static let moneyTrimDigit = 6
	private static let coinTrimDigit = 7

	// MARK: - Public Methods

	public static func trimmedValueOf(money moneyValue: Double) -> String {
		let moneyNumber = NSNumber(value: moneyValue)
		let numDigits = String(format: "%.0f", moneyValue).count

		if numDigits > moneyTrimDigit {
			formatter.maximumFractionDigits = 0
		}
		if numDigits == moneyTrimDigit {
			formatter.maximumFractionDigits = 1
		}
		if numDigits < moneyTrimDigit {
			formatter.maximumFractionDigits = 2
		}

		if let trimmedValue = formatter.string(from: moneyNumber) {
			return trimmedValue
		} else {
			fatalError("Failed to trimm the number")
		}
	}

	public static func trimmedValueOf(coin coinValue: Double) -> String {
		let coinNumber = NSNumber(value: coinValue)
		let numDigits = String(format: "%.0f", coinNumber).count

		formatter.maximumFractionDigits = coinTrimDigit - numDigits

		// |   SAMPLE NUMBER   | SHORTENED | FRACTION CNT |
		// ------------------------------------------------
		// | 1.343534534       | 1.343534  |      6       |
		// | 12.343534534      | 12.34353  |      5       |
		// | 124.343534534     | 126.3435  |      4       |
		// | 1245.343534534    | 1263.343  |      3       |
		// | 12634.343534534   | 12634.34  |      2       |
		// | 126343.343534534  | 126345.3  |      1       |
		// | 1263451.343534534 | 1263451   |      0       |

		if let trimmedValue = formatter.string(from: coinNumber) {
			return trimmedValue
		} else {
			fatalError("Failed to trimm the number")
		}
	}
}
