//
//  BigNumberGenerator.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 4/3/23.
//

import BigInt
import Foundation

/// The BigNumberGenerator class generates pairs of random decimal numbers and stores them in two arrays. It creates random decimals with varying whole and fraction digits and converts them to a BigNumberType tuple (BigInt, Int). The generate() method populates the arrays with random decimal numbers using a private helper method. This class is useful for generating random BigNumberType instances for testing or implementing mathematical operations.
class BigNumberGenerator {
	// MARK: - Typealias

	typealias BigNumberType = (BigInt, Int)

	// MARK: Public Properties

	public var decimalArray1 = [Decimal]()
	public var decimalArray2 = [Decimal]()
	public var arrayBig1: [BigNumberType] = []
	public var arrayBig2: [BigNumberType] = []
	public static let itemCount = 100

	// MARK: Private Methods

	private func generateRandomDecimals(decimalArray: inout [Decimal], bigArray: inout [BigNumberType]) {
		for _ in 1 ... BigNumberGenerator.itemCount {
			let randomWholeDigits = Int.random(in: 0 ... 10) // Generate a random number of whole digits
			let randomFractionDigits = Int.random(in: 0 ... 10) // Generate a random number of fraction digits
			let randomNumber = Double.random(in: 0 ..< 1) // Generate a random number between 0 and 1
			let decimalNumber = Decimal(
				sign: .plus,
				exponent: -randomFractionDigits,
				significand: Decimal(randomNumber) * pow(10, randomWholeDigits + randomFractionDigits)
			)
			decimalArray.append(decimalNumber)

			// Convert decimal value to BigInt
			let decimalString = String(describing: decimalNumber)
			let decimalComponents = decimalString.components(separatedBy: ".")
			let fractionPart = decimalComponents[1]
			let num = decimalString.replacingOccurrences(of: ".", with: "")
			let bigNum = BigInt(num)!
			bigArray.append((bigNum, fractionPart.count))
		}
	}

	// MARK: Public Methods

	public func generate() {
		generateRandomDecimals(decimalArray: &decimalArray1, bigArray: &arrayBig1)
		generateRandomDecimals(decimalArray: &decimalArray2, bigArray: &arrayBig2)
	}
}
