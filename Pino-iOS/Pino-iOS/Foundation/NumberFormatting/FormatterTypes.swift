//
//  FormatterTypes.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/28/23.
//

import Foundation

// MARK: - Public Properties

public struct PriceNumberFormatter: NumberFormatterProtocol {
    public let value: String
    public let decimal = 6
    public let formattingDecimal = 2
}

public struct HoldNumberFormatter: NumberFormatterProtocol {
    public let value: String
    public let decimal: Int
    public let formattingDecimal = 6
}
