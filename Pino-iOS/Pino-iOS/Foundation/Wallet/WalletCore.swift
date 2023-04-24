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
    case walletCreationFailed
    case accountAlreadyExists
    case accountNotFound
    case accountDeletionFailed
}

enum WalletValidatorError: LocalizedError {
    case privateKeyIsInvalid
    case publicKeyIsInvalid
    case addressIsInvalid
    case seedIsInvalid
    case mnemonicIsInvalid
}

enum KeyManagementError: LocalizedError {
    case seedStorageFailed
    case privateKeyStorageFailed
    case publicKeyStorageFailed
}

enum WalletOperationError: LocalizedError {
    case wallet(WalletError)
    case validator(WalletValidatorError)
    case keyManager(KeyManagementError)
}

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


//protocol WalletKeyHelper {
//    func saveSeedOfWallet(seed: Data, key: String)
//    func getSeedOfWallet(key: String) -> Date
//    func saveMnemonicsOfWallet(mnemonics: String) -> Bool
//
//    func getPrivateKeyOf(account: Account) -> Bool
//    func deletePrivateKeyOf(account: Account) -> Bool
//}

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
}

protocol PinoWallet {
    var id: String { get }
    var accounts: [Account] { get set }
    var error: WalletError { get set }
    var secureEnclave: SecureEnclave { get }
    var walletManagementDelegate: PinoWalletDelegate { get set }
    func accountExist(account: Account) -> Bool
    func deleteAccount(account: Account) -> Result<Account, WalletOperationError>
}

extension PinoWallet {
   
    func accountExist(account: Account) -> Bool {
        accounts.contains(where: { $0 == account })
    }
    
    func deleteAccount(account: Account) -> Result<Account, WalletOperationError> {
        guard let deletingAccount = accounts.first(where: { $0 == account }) else {
            return .failure(.wallet(.accountNotFound))
        }
        if KeychainManager.privateKey.deleteValueWith(key: deletingAccount.eip55Address) {
            return .success(deletingAccount)
        } else {
            return .failure(.wallet(.accountDeletionFailed))
        }
    }
    
}

protocol PHDWallet: PinoWallet {
    var seed: Data { get set }
    var mnemonic: String { get set }
    var entropy: Data { get }
    var hdWallet: HDWallet { get set }
    mutating func createWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError>
    func createAccount() -> Result<Account, WalletOperationError>
}

protocol PNonHDWallet: PinoWallet {
    mutating func importAccount(privateKey: Data) -> Result<Account, WalletOperationError>
}

protocol PinoWalletDelegate {
    func walletCreated(wallet: PinoWallet)
    func accountCreated(account: Account)
    func accountDeleted(account: Account)
}

public struct PinoHDWallet: PHDWallet {
    
    
    var seed: Data
    var mnemonic: String
    var entropy: Data
    var id: String
    var secureEnclave: SecureEnclave
    var accounts: [Account]
    var hdWallet: HDWallet
    var error: WalletError
    var walletManagementDelegate: PinoWalletDelegate
    
    mutating func createWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError> {
        guard WalletValidator.isMnemonicsValid(mnemonic: mnemonics) else {
            return .failure(.validator(.mnemonicIsInvalid))
        }
        guard let wallet = HDWallet(mnemonic: mnemonics, passphrase: .emptyString) else {
            return .failure(.wallet(.walletCreationFailed))
        }
        self.entropy = wallet.entropy
        self.seed = wallet.seed
        
        do {
            let firstAccountPrivateKey = getPrivateKeyOfFirstAccount(wallet: wallet)
            let account = try Account(privateKey: firstAccountPrivateKey)
            
            if !KeychainManager.seed.setValue(value: seed, key: account.eip55Address) {
                return .failure(.keyManager(.seedStorageFailed))
            }
            
            if accountExist(account: account) {
                return .failure(.wallet(.accountAlreadyExists))
            } else {
                self.hdWallet = wallet
                return .success(wallet)
            }
        } catch {
            return .failure(error as! WalletOperationError)
        }
    }
    
    
    func createAccount() -> Result<Account, WalletOperationError> {
        let coinType = CoinType.ethereum
        let derivationPath = "m/44'/60'/0'/0/1"
        let privateKey = hdWallet.getKey(coin: coinType, derivationPath: derivationPath)
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: false)
        let address = try! Account(publicKey: publicKey.data)
        
        print("Private Key: \(privateKey.data.hexString)")
        print("Public Key: \(publicKey.data.hexString)")
        print("Ethereum Address: \(address)")
    }
    
    func getPrivateKeyOfFirstAccount(wallet: HDWallet) -> Data {
        let firstAccountIndex = UInt32(0)
        let changeConstant = UInt32(0)
        let addressIndex = UInt32(0)
        let privateKey = wallet.getDerivedKey(coin: .ethereum, account: firstAccountIndex, change: changeConstant, address: addressIndex)
        return privateKey.data
    }
    
}

public struct PinoNonHDWallet: PNonHDWallet {
    
    var id: String
    var accounts: [Account]
    var error: WalletError
    var secureEnclave: SecureEnclave
    var walletValidator: WalletValidator
    var walletManagementDelegate: PinoWalletDelegate
    
    mutating func importAccount(privateKey: Data) -> Result<Account, WalletOperationError> {
        do {
            let account = try Account(privateKey: privateKey)
            guard accountExist(account: account) else { return .failure(.wallet(.accountAlreadyExists))}
            accounts.append(account)
            let keyCipherData = secureEnclave.encrypt(plainData: privateKey, withPublicKeyLabel: account.eip55Address)
            KeychainManager.privateKey.setValue(value: keyCipherData, key: account.eip55Address)
            return .success(account)
        } catch {
            return .failure(.wallet(.walletCreationFailed))
        }
    }
    
}

extension PinoNonHDWallet: Equatable {
    public static func == (lhs: PinoNonHDWallet, rhs: PinoNonHDWallet) -> Bool {
        lhs.id == rhs.id
    }
}

public struct Account {
    public var address: EthereumAddress
    public var isActiveAccount: Bool
    /// For Accounts derived from HDWallet
    public var derivationPath: String?
    public var publicKey: Data
    
    public var eip55Address: String {
        address.address
    }
    
    init(address: String, derivationPath: String? = nil, publicKey: Data) throws {
        guard let address = EthereumAddress(address) else { throw WalletValidatorError.addressIsInvalid }
        self.address = address
        self.isActiveAccount = true
        self.derivationPath = derivationPath
        self.publicKey = publicKey
    }
    
    init(privateKey: Data) throws {
        guard WalletValidator.isPrivateKeyValid(key: privateKey) else { throw WalletOperationError.validator(.privateKeyIsInvalid) }
        let publicKeyData = Utilities.privateToPublic(privateKey)
        guard let publicKey = publicKeyData, WalletValidator.isPublicKeyValid(key: publicKey) else {
            throw WalletOperationError.validator(.publicKeyIsInvalid)
        }
        guard let address = Utilities.publicToAddress(publicKey) else {
            throw WalletOperationError.validator(.addressIsInvalid)
        }
        self.derivationPath = nil
        self.publicKey = publicKey
        self.address = address
        self.isActiveAccount = true
    }
    
    init(publicKey: Data) throws {
        guard WalletValidator.isPublicKeyValid(key: publicKey) else {
            throw WalletOperationError.validator(.publicKeyIsInvalid)
        }
        guard let address = Utilities.publicToAddress(publicKey) else {
            throw WalletOperationError.validator(.addressIsInvalid)
        }
        self.derivationPath = nil
        self.publicKey = publicKey
        self.address = address
        self.isActiveAccount = true
    }
    
}

extension Account: Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.address == rhs.address
    }
}
