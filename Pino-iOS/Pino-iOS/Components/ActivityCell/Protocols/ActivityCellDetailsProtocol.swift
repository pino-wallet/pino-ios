//
//  ActivityDetailsProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//

import Foundation

protocol ActivityCellDetailsProtocol {
    var token: AssetViewModel { get set }
}

extension ActivityCellDetailsProtocol {
    var tokenSymbol: String {
        token.symbol
    }
    
    var tokenImage: URL? {
        token.image
    }
}
