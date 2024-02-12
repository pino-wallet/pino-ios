//
//  NumberFormatting.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/13/23.
//

import Foundation

public enum NumberFormatTypes {
	case sevenDigitsRule
	case priceRule
	case chartPriceRule
	case percentRule

	public func formattingDecimal(wholeNumDigitsCount: Int) -> Int {
		switch self {
		case .sevenDigitsRule:
			if wholeNumDigitsCount > 7 {
				return 0
			}
			return 7 - wholeNumDigitsCount
		case .priceRule:
			switch wholeNumDigitsCount {
			case _ where wholeNumDigitsCount >= 5:
				return 0
			case _ where wholeNumDigitsCount < 5 && wholeNumDigitsCount > 2:
				return 1
			case _ where wholeNumDigitsCount <= 2:
				return 2
			default:
				return 2
			}
		case .chartPriceRule:
			return 2
		case .percentRule:
			return 2
		}
	}
}
