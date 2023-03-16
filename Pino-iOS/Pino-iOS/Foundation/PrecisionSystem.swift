//
//  PrecisionSystem.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/11/23.
//

import Foundation
import BigInt

class PercisionCalculate {
	private static let formatter = NumberFormatter()
    private static let moneyTrimDigit = 6
    private static let coinTrimDigit = 7

	static func trimmedValueOf(money moneyValue: Double) -> String {
		let moneyNumber = NSNumber(value: moneyValue)
		formatter.numberStyle = .decimal

		let numDigits = String(format: "%.0f", moneyValue).count
		print("\(moneyValue) : \(numDigits)")

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

	static func trimmedValueOf(coin coinValue: BigInt) -> String {
//        let coinNumber = NSNumber(value: coinValue)
        formatter.numberStyle = .decimal

//        let numDigits = String(format: "%.0f", coinValue).count
    
        formatter.maximumFractionDigits = coinTrimDigit - coinValue.words.count
        
        // |   SAMPLE NUMBER   | SHORTENED | FRACTION CNT |
        // ------------------------------------------------
        // | 1.343534534       | 1.343534  |      6       |
        // | 12.343534534      | 12.34353  |      5       |
        // | 124.343534534     | 126.3435  |      4       |
        // | 1245.343534534    | 1263.343  |      3       |
        // | 12634.343534534   | 12634.34  |      2       |
        // | 126343.343534534  | 126345.3  |      1       |
        // | 1263451.343534534 | 1263451   |      0       |
        
        return coinValue.description
        
//        if let trimmedValue = formatter.string(from: coinNumber) {
//            return trimmedValue
//        } else {
//            fatalError("Failed to trimm the number")
//        }
	}
}
