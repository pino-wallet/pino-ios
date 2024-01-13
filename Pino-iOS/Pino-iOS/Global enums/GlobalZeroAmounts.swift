//
//  ZeroAmounts.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/13/24.
//

import Foundation

enum GlobalZeroAmounts {
    case dollars
    case tokenAmount
    case percentage
    
    public var zeroAmount: String {
        switch self {
        case .dollars:
            "$0.00"
        case .tokenAmount:
            "0.00"
        case .percentage:
            "0.00%"
        }
    }
}
