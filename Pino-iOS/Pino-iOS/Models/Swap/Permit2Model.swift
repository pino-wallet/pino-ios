//
//  Permit2Model.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/9/23.
//

import Foundation
import Web3
import Web3ContractABI

struct TokenPermissions: ABIEncodable {
    let token: EthereumAddress
    let amount: EthereumQuantity
    
    func abiEncode(dynamic: Bool) -> String? {
        guard let tokenEncoded = token.abiEncode(dynamic: false),
              let amountEncoded = amount.quantity.abiEncode(dynamic: false) else {
            return nil
        }
        return tokenEncoded + amountEncoded
    }
}



struct Permit2Model: ABIEncodable {
    let permitted: TokenPermissions
    let nonce: EthereumQuantity
    let deadline: EthereumQuantity
    
    func abiEncode(dynamic: Bool) -> String? {
        guard let tokenPermissionsEncoded = permitted.abiEncode(dynamic: false),
              let nonceEncoded = nonce.quantity.abiEncode(dynamic: false),
              let deadlineEncoded = deadline.quantity.abiEncode(dynamic: false) else {
            return nil
        }
        return tokenPermissionsEncoded + nonceEncoded + deadlineEncoded
    }
}


struct PermitTransferFrom: ABIEncodable {
    let permitted: Permit2Model
    let signature: [UInt8]
    
    func abiEncode(dynamic: Bool) -> String? {
        guard let permittedEncoded = permitted.abiEncode(dynamic: false) else {
            return nil
        }
        
        // Convert signature bytes to hexadecimal string.
        let signatureEncoded = signature.reduce("") { $0 + String(format: "%02x", $1) }
        
        // Assuming that both the permitted and the signature need to be concatenated.
        // Adjust this if your contract expects a different format.
        return permittedEncoded + signatureEncoded
    }
}

