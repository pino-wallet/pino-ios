//
//  KeychainManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

enum KeychainManager: String {

    case mnemonics
    case seed
    case privateKey

    func getValueWith(key: String) -> Data {
        let keychainHelper = KeychainSwift()
        return keychainHelper.getData("\(self)\(key)")!
    }
    
    func setValue(value: Data, key: String) -> Bool {
        let keychainHelper = KeychainSwift()
        return keychainHelper.set(value, forKey: "\(self)\(key)")
    }
    
    func setValue(value: String, key: String) -> Bool {
        let keychainHelper = KeychainSwift()
        return keychainHelper.set(value, forKey: "\(self)\(key)")
    }
    
    func deleteValueWith(key: String) -> Bool {
        let keychainHelper = KeychainSwift()
        return keychainHelper.delete("\(self)\(key)")
    }
    
    func getKey(account: Account) -> String {
        "\(self)\(account.eip55Address)"
    }
}
