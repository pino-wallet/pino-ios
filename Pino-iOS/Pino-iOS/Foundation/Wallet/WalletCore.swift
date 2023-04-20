//
//  WalletCore.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/16/23.
//

import Foundation
import WalletCore
import Web3Core

enum WalletError: LocalizedError {
    case mnemonicGenerationFailed
    case mnemonicIsInvalid
    case walletCreationFailed
}

enum WalletValidatorError: LocalizedError {
    case privateKeyIsInvalid
    case publicKeyIsInvalid
    case addressIsInvalid
    case seedIsInvalid
}

public class WalletValidator {
    func isPrivateKeyValid(key: Data) -> Bool {
        PrivateKey.isValid(data: key, curve: .secp256k1)
    }
    func isPublicKeyValid(key: Data) -> Bool {
        PublicKey.isValid(data: key, type: .secp256k1)
    }
    func isMnemonicsValid(mnemonic: String) -> Bool {
        Mnemonic.isValid(mnemonic: mnemonic)
    }
    func isMnemonicsValid(mnemonic: [String]) -> Bool {
        return Mnemonic.isValid(mnemonic: mnemonic.joined())
    }
    func isEthAddressValid(address: String) -> Bool {
        AnyAddress.isValid(string: address, coin: .ethereum)
    }
}


protocol WalletKeyHelper {
    func deletePrivateKeyOf(account: Account) -> Bool
    func getPrivateKeyOf(account: Account) -> Bool
    func saveSeedOf(account: Account) -> Bool
    func getSeedOf(account: Account) -> Bool
    func saveMnemonicsOf(account: Account) -> Bool
    func keychainKeyOf(acccount: Account)
}

protocol PinoWallet {
    var id: String { get }
    var accounts: [Account] { get set }
    var error: WalletError { get set }
    var secureEnclave: SecureEnclave { get }
    var walletValidator: WalletValidator { get }
    var keyManagement: WalletKeyHelper { get set }
    var walletManagementDelegate: PinoWalletDelegate { get set }
    func accountExist() -> Bool
    func deleteAccount() -> Result<Account, WalletError>
    static func == (lhs: PinoWallet, rhs: PinoWallet) -> Bool
}

protocol PHDWallet: PinoWallet {
    var seed: Data { get set }
    var mnemonic: String { get set }
    var entropy: Data { get }
    func createWallet(mnemonics: String)
    func createAccount() -> Result<Account, WalletError>
}

protocol PNonHDWallet: PinoWallet {
    func importAccount() -> Result<Account, WalletError>
}

protocol PinoWalletDelegate {
    func walletCreated(wallet: PinoWallet)
    func accountCreated(account: Account)
    func accountDeleted(account: Account)
}

public struct PinoHDWallet: PHDWallet {
    
}

public struct PinoNonHDWallet: PNonHDWallet {
    
}

public struct Account {
    public var address: Address
    public var isActiveAccount: Bool
}

public struct Address {

    /// Raw address bytes, length 20.
    public private(set) var data: Data

    /// EIP55 representation of the address.
    public let eip55String: String

    /// Creates an address with an EIP55 string representation.
    ///
    /// This initializer will fail if the EIP55 string fails validation.
    public init?(string: String) {
        guard let address = Address(string: string.addHexPrefix()) else {
            return nil
        }
        self.eip55String = address.eip55String
        self.data = address.data
    }
}

extension Address: CustomStringConvertible {
    //TODO should not be using this in production code
    public var description: String {
        return eip55String
    }
}

extension Address: Equatable {
    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.data == rhs.data
    }
}
