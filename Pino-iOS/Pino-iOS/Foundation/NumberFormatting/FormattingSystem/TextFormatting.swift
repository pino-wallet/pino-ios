//
//  TextFormatting.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/13/23.
//

import Foundation

protocol TextFormattingSystem {
    
    var currencyFormatting: String { get }
    var ethFormatting: String { get }
    var percentFormatting: String { get }

}

extension TextFormattingSystem {
    
    // MARK: - Public Properties

    public var currencyFormatting: String {
        return preWordFormatting(char: currentCurrency)
    }
    
    public var ethFormatting: String {
        return tokenFormatting(token: "ETH")
    }
    
    public var percentFormatting: String {
        return preWordFormatting(char: "%")
    }
    
    private var currentCurrency: String {
        return "$"
    }
    
    // MARK: - Private Methods
    
    private func preWordFormatting(char: String) -> String {
        return "\(char)\(self)"
    }
    
    public func tokenFormatting(token: String) -> String {
        return "\(self) \(token)"
    }
    
}

extension String: TextFormattingSystem { }
extension Double: TextFormattingSystem { }
