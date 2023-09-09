//
//  Permit2Model.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/9/23.
//

import Foundation
import Web3
import Web3ContractABI

struct Permit2Model: ABIEncodable {
    
    struct TokenPermissions {
        let token: EthereumAddress
        let amount: EthereumQuantity
    }
    
    let permitted: TokenPermissions
    let nonce: EthereumQuantity
    let deadline: EthereumQuantity
    
    func abiEncode(dynamic: Bool) -> String? {
        
        // Encoding TokenPermissions
        let tokenEncoded = permitted.token.abiEncode(dynamic: false)
        let amountEncoded = permitted.amount.quantity.abiEncode(dynamic: false)
        
        // Encoding PermitTransferFrom
        let nonceEncoded = nonce.quantity.abiEncode(dynamic: false)
        let deadlineEncoded = deadline.quantity.abiEncode(dynamic: false)
        
        // Concatenate all the encoded strings
        var encodedString = tokenEncoded! + amountEncoded! + nonceEncoded! + deadlineEncoded!
        
        return encodedString
    }
    
}
