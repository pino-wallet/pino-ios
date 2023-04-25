//
//  WalletValidator.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

public class WalletValidator {
    
    static func isPrivateKeyValid(key: Data) -> Bool {
        PrivateKey.isValid(data: key, curve: .secp256k1)
    }
    static func isPublicKeyValid(key: Data) -> Bool {
        PublicKey.isValid(data: key, type: .secp256k1)
    }
    static func isMnemonicsValid(mnemonic: String) -> Bool {
        Mnemonic.isValid(mnemonic: mnemonic)
    }
    static func isMnemonicsValid(mnemonic: [String]) -> Bool {
        return Mnemonic.isValid(mnemonic: mnemonic.joined())
    }
    static func isEthAddressValid(address: String) -> Bool {
        AnyAddress.isValid(string: address, coin: .ethereum)
    }
}
