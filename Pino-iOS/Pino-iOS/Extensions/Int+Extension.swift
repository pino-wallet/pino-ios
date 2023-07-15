//
//  Int+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/15/23.
//

import Foundation

extension Int {
    
    public var bigNumber: BigNumber {
        return BigNumber(number: self.description, decimal: 0)
    }
    
}
