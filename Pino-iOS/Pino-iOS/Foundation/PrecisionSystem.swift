//
//  PrecisionSystem.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/11/23.
//

import Foundation
import BigInt
import Web3Core

class NumberPercisionFormatter {
    
    private static let formatter = NumberFormatter()
    private static let moneyTrimDigit = 6
    private static let coinTrimDigit = 7
    private let maximumFractionDigits = 4
    
    public static let decimalPoint = "."
    
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
    
    static func trimmedValueOf(coin coinValue: Double) -> String {
        let coinNumber = NSNumber(value: coinValue)
        formatter.numberStyle = .decimal
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
    
    public var formattedAmount: String {
        Utilities.formatToPrecision(bigValue, units: .custom(decimal), formattingDecimals: formattingDecimal, decimalSeparator: ".", fallbackToScientific: false)
    }
    
    public var bigValue: BigInt {
        return BigInt(value)!
    }
    
    public var doubleValue: Double {
        return value.doubleValue!
    }
    
    public var formattedBigValue: BigInt {
        return BigInt(formattedAmount)!
    }
    
    public var formattedDoubleValue: Double {
        return formattedAmount.doubleValue!
    }
    
}

public struct PriceNumberFormatter: NumberFormatterProtocol {
    
    public let value: String
    public let decimal: Int = 6
    public let formattingDecimal: Int = 2
   
}

public struct HoldNumberFormatter: NumberFormatterProtocol {
    
    public let value: String
    public let decimal: Int
    public let formattingDecimal: Int = 6
   
}
