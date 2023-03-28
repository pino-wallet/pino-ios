//
//  NumberFormatterProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/28/23.
//

import BigInt
import Foundation
import Web3Core

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
