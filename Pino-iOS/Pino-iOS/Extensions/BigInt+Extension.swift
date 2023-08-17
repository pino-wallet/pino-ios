//
//  BigInt+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/4/23.
//

import BigInt
import Foundation
import Web3

extension BigInt {
	/// This function is suitable for testing big numbers
	///  Sample : Converts 231231000000 -> 231231
	/// - Returns: Trimmed without zero BigInt number
	public func trimmedTrailingZeros() -> Self {
		let stringValue = String(describing: self)
		let trimmedString = stringValue.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
		let trimmedBigInt = BigInt(trimmedString) ?? 0
		return trimmedBigInt
	}
    
}

extension BigUInt {
    public var etherumQuantity: EthereumQuantity {
        .init(quantity: self)
    }
}
