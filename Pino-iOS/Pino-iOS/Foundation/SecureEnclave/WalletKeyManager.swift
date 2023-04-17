//
//  WalletKeyManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/17/23.
//

import Foundation
import LocalAuthentication

private protocol WalletKeyManager {
    func savePrivateKeyForNonHdWallet(_ privateKey: Data, forAccount account: Address, withUserPresence: Bool) -> Bool
    func saveSeedForHdWallet(_ seed: String, forAccount account: Address, withUserPresence: Bool) -> Bool
    func decryptHdWalletSeed(fromCipherTextData cipherTextData: Data, forAccount account: Address, withUserPresence: Bool, withContext context: LAContext) -> Data?
    func decryptPrivateKey(fromCipherTextData cipherTextData: Data, forAccount account: Address, withUserPresence: Bool, withContext context: LAContext) -> Data?
    func encryptHdWalletSeed(_ seed: Data, forAccount account: Address, withUserPresence: Bool, withContext context: LAContext) -> Data?
    func encryptPrivateKey(_ key: Data, forAccount account: Address, withUserPresence: Bool, withContext context: LAContext) -> Data?
    func encryptionKeyForSeedLabel(fromAccount account: Address, withUserPresence: Bool) -> String
    func encryptionKeyForPrivateKeyLabel(fromAccount account: Address, withUserPresence: Bool) -> String
    func getPrivateKeyFromHdWallet0thAddress(forAccount account: Address, prompt: String, withUserPresence: Bool) -> WalletSeedOrKey
    func getPrivateKeyFromNonHdWallet(forAccount account: Address, prompt: String, withUserPresence: Bool, shouldWriteWithUserPresenceIfNotFound: Bool = true) -> WalletSeedOrKey
    func getSeedPhraseForHdWallet(forAccount account: Address, prompt: String, context: LAContext, withUserPresence: Bool) -> WalletSeedOrKey
    func getSeedForHdWallet(forAccount account: Address, prompt: String, context: LAContext, withUserPresence: Bool, shouldWriteWithUserPresenceIfNotFound: Bool = true) -> WalletSeedOrKey
}

public struct PinoWalletKeyManager: WalletKeyManager {
    
    private func getPrivateKeyFromHdWallet0thAddress(forAccount account: AlphaWallet.Address, prompt: String, withUserPresence: Bool) -> WalletSeedOrKey {
        guard isHdWallet(account: account) else {
            assertImpossibleCodePath()
            return .otherFailure
        }
        let seedResult = getSeedForHdWallet(forAccount: account, prompt: prompt, context: createContext(), withUserPresence: withUserPresence)
        switch seedResult {
        case .seed(let seed):
            if let wallet = HDWallet(seed: seed, passphrase: functional.emptyPassphrase) {
                let privateKey = functional.derivePrivateKeyOfAccount0(fromHdWallet: wallet)
                return .key(privateKey)
            } else {
                return .otherFailure
            }
        case .userCancelled, .notFound, .otherFailure:
            return seedResult
        case .key, .seedPhrase:
            //Not possible
            return .otherFailure
        }
    }

    private func getPrivateKeyFromNonHdWallet(forAccount account: AlphaWallet.Address, prompt: String, withUserPresence: Bool, shouldWriteWithUserPresenceIfNotFound: Bool = true) -> WalletSeedOrKey {
        let prefix: String
        if withUserPresence {
            prefix = Keys.ethereumRawPrivateKeyUserPresenceRequiredPrefix
        } else {
            prefix = Keys.ethereumRawPrivateKeyUserPresenceNotRequiredPrefix
        }
        let context = createContext()
        let data = keychain.getData("\(prefix)\(account.eip55String)", prompt: prompt, withContext: context)
                .flatMap { decryptPrivateKey(fromCipherTextData: $0, forAccount: account, withUserPresence: withUserPresence, withContext: context) }

        //We copy the record that doesn't require user-presence make a new one which requires user-presence and read from that. We don't want to read the one without user-presence unless absolutely necessary (e.g user has disabled passcode)
        if data == nil && withUserPresence && shouldWriteWithUserPresenceIfNotFound && keychain.isDataNotFoundForLastAccess {
            switch getPrivateKeyFromNonHdWallet(forAccount: account, prompt: prompt, withUserPresence: false, shouldWriteWithUserPresenceIfNotFound: false) {
            case .seed, .seedPhrase:
                //Not possible
                break
            case .key(let keyWithoutUserPresence):
                let _ = savePrivateKeyForNonHdWallet(keyWithoutUserPresence, forAccount: account, withUserPresence: true)
            case .userCancelled, .notFound, .otherFailure:
                break
            }
            return getPrivateKeyFromNonHdWallet(forAccount: account, prompt: prompt, withUserPresence: true, shouldWriteWithUserPresenceIfNotFound: false)
        } else {
            if let data = data {
                return .key(data)
            } else {
                if keychain.hasUserCancelledLastAccess {
                    return .userCancelled
                } else if keychain.isDataNotFoundForLastAccess {
                    return .notFound
                } else {
                    return .otherFailure
                }
            }
        }
    }

    private func getSeedPhraseForHdWallet(forAccount account: AlphaWallet.Address, prompt: String, context: LAContext, withUserPresence: Bool) -> WalletSeedOrKey {
        let seedOrKey = getSeedForHdWallet(forAccount: account, prompt: prompt, context: context, withUserPresence: withUserPresence)
        switch seedOrKey {
        case .seed(let seed):
            if let wallet = HDWallet(seed: seed, passphrase: functional.emptyPassphrase) {
                return .seedPhrase(wallet.mnemonic)
            } else {
                return .otherFailure
            }
        case .seedPhrase, .key:
            //Not possible
            return seedOrKey
        case .userCancelled, .notFound, .otherFailure:
            return seedOrKey
        }
    }

    private func getSeedForHdWallet(forAccount account: AlphaWallet.Address, prompt: String, context: LAContext, withUserPresence: Bool, shouldWriteWithUserPresenceIfNotFound: Bool = true) -> WalletSeedOrKey {
        let prefix: String
        if withUserPresence {
            prefix = Keys.ethereumSeedUserPresenceRequiredPrefix
        } else {
            prefix = Keys.ethereumSeedUserPresenceNotRequiredPrefix
        }
        let data = keychain.getData("\(prefix)\(account.eip55String)", prompt: prompt, withContext: context)
                .flatMap { decryptHdWalletSeed(fromCipherTextData: $0, forAccount: account, withUserPresence: withUserPresence, withContext: context) }
                .flatMap { String(data: $0, encoding: .utf8) }
        //We copy the record that doesn't require user-presence make a new one which requires user-presence and read from that. We don't want to read the one without user-presence unless absolutely necessary (e.g user has disabled passcode)
        if data == nil && withUserPresence && shouldWriteWithUserPresenceIfNotFound && keychain.isDataNotFoundForLastAccess {
            switch getSeedForHdWallet(forAccount: account, prompt: prompt, context: createContext(), withUserPresence: false, shouldWriteWithUserPresenceIfNotFound: false) {
            case .seed(let seedWithoutUserPresence):
                let _ = saveSeedForHdWallet(seedWithoutUserPresence, forAccount: account, withUserPresence: true)
            case .key, .seedPhrase:
                //Not possible
                break
            case .userCancelled, .notFound, .otherFailure:
                break
            }
            return getSeedForHdWallet(forAccount: account, prompt: prompt, context: createContext(), withUserPresence: true, shouldWriteWithUserPresenceIfNotFound: false)
        } else {
            if let data = data {
                return .seed(data)
            } else {
                if keychain.hasUserCancelledLastAccess {
                    return .userCancelled
                } else if keychain.isDataNotFoundForLastAccess {
                    return .notFound
                } else {
                    return .otherFailure
                }
            }
        }
    }
    
    private func savePrivateKeyForNonHdWallet(_ privateKey: Data, forAccount account: AlphaWallet.Address, withUserPresence: Bool) -> Bool {
        let context = createContext()
        guard let cipherTextData = encryptPrivateKey(privateKey, forAccount: account, withUserPresence: withUserPresence, withContext: context) else { return false }
        let access: AccessOptions
        let prefix: String
        if withUserPresence {
            access = defaultKeychainAccessUserPresenceRequired
            prefix = Keys.ethereumRawPrivateKeyUserPresenceRequiredPrefix
        } else {
            access = defaultKeychainAccessUserPresenceNotRequired
            prefix = Keys.ethereumRawPrivateKeyUserPresenceNotRequiredPrefix
        }
        return keychain.set(cipherTextData, forKey: "\(prefix)\(account.eip55String)", withAccess: access)
    }
    
    private func saveSeedForHdWallet(_ seed: String, forAccount account: AlphaWallet.Address, withUserPresence: Bool) -> Bool {
        let context = createContext()
        guard let cipherTextData = seed.data(using: .utf8).flatMap({ self.encryptHdWalletSeed($0, forAccount: account, withUserPresence: withUserPresence, withContext: context) }) else { return false }
        let access: AccessOptions
        let prefix: String
        if withUserPresence {
            access = defaultKeychainAccessUserPresenceRequired
            prefix = Keys.ethereumSeedUserPresenceRequiredPrefix
        } else {
            access = defaultKeychainAccessUserPresenceNotRequired
            prefix = Keys.ethereumSeedUserPresenceNotRequiredPrefix
        }
        return keychain.set(cipherTextData, forKey: "\(prefix)\(account.eip55String)", withAccess: access)
    }
    
    private func decryptHdWalletSeed(fromCipherTextData cipherTextData: Data, forAccount account: AlphaWallet.Address, withUserPresence: Bool, withContext context: LAContext) -> Data? {
        let secureEnclave = SecureEnclave(userPresenceRequired: withUserPresence)
        return try? secureEnclave.decrypt(cipherText: cipherTextData, withPrivateKeyFromLabel: encryptionKeyForSeedLabel(fromAccount: account, withUserPresence: withUserPresence), withContext: context)
    }
    
    private func decryptPrivateKey(fromCipherTextData cipherTextData: Data, forAccount account: AlphaWallet.Address, withUserPresence: Bool, withContext context: LAContext) -> Data? {
        let secureEnclave = SecureEnclave(userPresenceRequired: withUserPresence)
        return try? secureEnclave.decrypt(cipherText: cipherTextData, withPrivateKeyFromLabel: encryptionKeyForPrivateKeyLabel(fromAccount: account, withUserPresence: withUserPresence), withContext: context)
    }
    
    private func encryptHdWalletSeed(_ seed: Data, forAccount account: AlphaWallet.Address, withUserPresence: Bool, withContext context: LAContext) -> Data? {
        let secureEnclave = SecureEnclave(userPresenceRequired: withUserPresence)
        return try? secureEnclave.encrypt(plainTextData: seed, withPublicKeyFromLabel: encryptionKeyForSeedLabel(fromAccount: account, withUserPresence: withUserPresence), withContext: context)
    }
    
    private func encryptPrivateKey(_ key: Data, forAccount account: AlphaWallet.Address, withUserPresence: Bool, withContext context: LAContext) -> Data? {
        let secureEnclave = SecureEnclave(userPresenceRequired: withUserPresence)
        return try? secureEnclave.encrypt(plainTextData: key, withPublicKeyFromLabel: encryptionKeyForPrivateKeyLabel(fromAccount: account, withUserPresence: withUserPresence), withContext: context)
    }
    
    private func encryptionKeyForSeedLabel(fromAccount account: AlphaWallet.Address, withUserPresence: Bool) -> String {
        let prefix: String
        if withUserPresence {
            prefix = Keys.encryptionKeyForSeedUserPresenceRequiredPrefix
        } else {
            prefix = Keys.encryptionKeyForSeedUserPresenceNotRequiredPrefix
        }
        return "\(prefix)\(account.eip55String)"
    }
    
    private func encryptionKeyForPrivateKeyLabel(fromAccount account: AlphaWallet.Address, withUserPresence: Bool) -> String {
        let prefix: String
        if withUserPresence {
            prefix = Keys.encryptionKeyForPrivateKeyUserPresenceRequiredPrefix
        } else {
            prefix = Keys.encryptionKeyForPrivateKeyUserPresenceNotRequiredPrefix
        }
        return "\(prefix)\(account.eip55String)"
    }
    
    
}
