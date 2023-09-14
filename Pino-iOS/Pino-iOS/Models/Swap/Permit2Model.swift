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

struct PermitTransferModel: ABIEncodable {
    
    let _permit: Permit2Model
    let _signature: String
    
    func abiEncode(dynamic: Bool) -> String? {
        guard let encodedPermit = _permit.abiEncode(dynamic: false),
              let encodedSig = _signature.abiEncode(dynamic: false) else {
            return nil
        }
        return encodedPermit + encodedSig
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
