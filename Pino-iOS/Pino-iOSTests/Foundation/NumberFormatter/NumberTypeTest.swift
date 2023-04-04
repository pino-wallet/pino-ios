//
//  NumberTypeTest.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 4/3/23.
//

import BigInt
@testable import Pino_iOS
import XCTest

final class NumberTypeTest: XCTestCase {
	let bigNumberGenerator = BigNumberGenerator()
	var mockNumbersArray1: [NumberType] = []
	var mockNumbersArray2: [NumberType] = []

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		bigNumberGenerator.generate()
		mockNumbersArray1 = bigNumberGenerator.arrayBig1.map { number, decimal in
			NumberType(number: number, decimal: decimal)
		}
		mockNumbersArray2 = bigNumberGenerator.arrayBig2.map { number, decimal in
			NumberType(number: number, decimal: decimal)
		}
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testNumberTypePlus() {
		for (index, _) in mockNumbersArray1.enumerated() {
			let a = mockNumbersArray1[index] + mockNumbersArray2[index]
			let b = bigNumberGenerator.decimalArray1[index] + bigNumberGenerator.decimalArray2[index]
			let bigDecimal = BigInt(b.withoutDeicmalDot())!

			XCTAssertEqual(a.number.trimmedTrailingZeros(), bigDecimal)
		}
	}

	func testNumberTypeDeduction() {
		for (index, _) in mockNumbersArray1.enumerated() {
			let a = mockNumbersArray1[index] - mockNumbersArray2[index]
			let b = bigNumberGenerator.decimalArray1[index] - bigNumberGenerator.decimalArray2[index]
			let bigDecimal = BigInt(b.withoutDeicmalDot())!

			XCTAssertEqual(a.number.trimmedTrailingZeros(), bigDecimal)
		}
	}

	func testNumberTypeMultiply() {
		for (index, _) in mockNumbersArray1.enumerated() {
			let a = mockNumbersArray1[index] * mockNumbersArray2[index]
			let b = bigNumberGenerator.arrayBig1[index].0 * bigNumberGenerator.arrayBig2[index].0
			XCTAssertEqual(a.number, b)
		}
	}
}
