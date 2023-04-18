//
//  WalletCore.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/16/23.
//

import Foundation

enum WalletError: LocalizedError {
    case mnemonicGenerationFailed
    case mnemonicIsInvalid
    case walletCreationFailed
}

public enum Seed {
    case stringValue
    case arrayValue
}

public struct Key {
    let privateKey: Data
    let publicKey: Data
}

public struct PHDWallet {
    let id: String
    let seed: Seed
    let key: Key
    let accounts: [Account] = []
    let importType: ImportType
    let entropy: Data
    
    enum ImportType {
        case mnemonics
        case privateKey
        case newWallet
    }
}

public class Validator {
    func validatePrivateKey()
    func validatePublicKey()
    func validateMnemonics()
    func validateAddress()
}

public struct Account {
    public var address: Address

}

public struct Address {

    /// Raw address bytes, length 20.
    public private(set) var data: Data

    /// EIP55 representation of the address.
    public let eip55String: String

    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.data == rhs.data
    }

    /// Creates an address with an EIP55 string representation.
    ///
    /// This initializer will fail if the EIP55 string fails validation.
    public init?(eip55 string: String) {
        guard let data = Data(hexString: string), data.count == 20 else {
            return nil
        }
        self.data = data
        let notBurnAddress = Address.checkNotBurnAddress(data: data)
        if !notBurnAddress {
            return nil
        }
        eip55String = Address.computeEIP55String(for: data)
        if eip55String != string {
            return nil
        }
    }
}

typealias Mnemonics = [String]

protocol WalletCoreManagment {
    func createHDWallet() -> Result<PHDWallet, WalletError>
    func restoreWallet(with mnemonics:Seed) -> Result<PHDWallet, WalletError>
    func restoreWallet(with privateKey:Seed) -> Result<PHDWallet, WalletError>
    func delete(wallet: PHDWallet)
}

public class PinoWalletCore: WalletCoreManagment {
    
    func createHDWallet() -> Result<PHDWallet, WalletError> {
        // 1: Create Mnemonics
        let mnemonicStr = HDWallet.generateMnemonic(seedPhraseCount: .word12)
        let mnemonic: Mnemonics = mnemonicStr.split(separator: " ").map { String($0) }

        // 2: Create HDWallet
        guard let hdWallet = HDWallet(mnemonic: mnemonicStr, passphrase: .emptyString) else { return .failure(WalletError.walletCreationFailed) }
        let privateKey = functional.derivePrivateKeyOfAccount0(fromHdWallet: hdWallet)
        
        guard let address = AlphaWallet.Address(fromPrivateKey: privateKey) else { return .failure(KeystoreError.failedToCreateWallet) }
        guard !isAddressAlreadyInWalletsList(address: address) else { return .failure(KeystoreError.duplicateAccount) }
        let seed = HDWallet.computeSeedWithChecksum(fromSeedPhrase: mnemonicString)
        let isSuccessful = saveSeedForHdWallet(seed, forAccount: address, withUserPresence: false)
        guard isSuccessful else { return .failure(KeystoreError.failedToCreateWallet) }
        let _ = saveSeedForHdWallet(seed, forAccount: address, withUserPresence: true)

        return .success(Wallet(address: address, origin: .hd))
    }
    
    func restoreWallet(with mnemonics: Mnemonics) -> Result<Wallet, WalletError> {
        
    }
    
    func restoreWallet(with privateKey:Seed) -> Result<PHDWallet, WalletError> {

    }
    
    func delete(wallet: Wallet) {
        
    }
    
    
}
