//
//  PinoHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

protocol PHDWallet: PinoWallet {
	func createHDWallet(mnemonics: String) throws -> Result<HDWallet, WalletOperationError>
	func createHDWallet(seed: Data) -> Result<HDWallet, WalletOperationError>
    func createAccountIn(wallet: HDWallet) throws -> Result<Account, WalletOperationError>
}

public class PinoHDWallet: PHDWallet {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()

	// MARK: - Public Properties

	public var accounts: [Account] {
		getAllAccounts()
	}
    
    #warning("this is for testing purposes")
    private var tempAccounts: [Account] = []

	// MARK: - Public Methods

	public func createHDWallet(mnemonics: String) -> Result<HDWallet, WalletOperationError> {
		guard WalletValidator.isMnemonicsValid(mnemonic: mnemonics) else {
			return .failure(.validator(.mnemonicIsInvalid))
		}
		guard let wallet = HDWallet(mnemonic: mnemonics, passphrase: .emptyString) else {
			return .failure(.wallet(.walletCreationFailed))
		}

		do {
			let firstAccountPrivateKey = getPrivateKeyOfFirstAccount(wallet: wallet)
			let account = try Account(privateKeyData: firstAccountPrivateKey)

			let encryptedSeedData = encryptHdWalletSeed(wallet.seed, forAccount: account)
			if !KeychainManager.seed.setValue(value: encryptedSeedData, key: account.eip55Address) {
				return .failure(.keyManager(.seedStorageFailed))
			}

			if accountExist(account: account) {
				return .failure(.wallet(.accountAlreadyExists))
			} else {
				addNewAccount(account)
				return .success(wallet)
			}
		} catch let error where error is WalletOperationError {
			return .failure(error as! WalletOperationError)
		} catch {
			return .failure(.wallet(.unknownError))
		}
	}

	public func createHDWallet(seed: Data) -> Result<HDWallet, WalletOperationError> {
		let hdWallet = HDWallet(entropy: seed, passphrase: .emptyString)
		if let hdWallet {
			return .success(hdWallet)
		} else {
			return .failure(.wallet(.walletCreationFailed))
		}
	}

	public func createAccountIn(wallet: HDWallet) throws -> Result<Account, WalletOperationError> {
		let coinType = CoinType.ethereum
		let derivationPath = "m/44'/60'/0'/0/\(getAllAccounts().count)"
		let privateKey = wallet.getKey(coin: coinType, derivationPath: derivationPath)
		let publicKey = privateKey.getPublicKeySecp256k1(compressed: false)
		let account = try Account(publicKey: publicKey.data)
		addNewAccount(account)
		print("Private Key: \(privateKey.data.hexString)")
		print("Public Key: \(publicKey.data.hexString)")
		print("Ethereum Address: \(account)")
		return .success(account)
	}

	#warning("should read accounts from core data")
	public func getAllAccounts() -> [Account] {
		tempAccounts
	}

	#warning("write account to core data")
	public func addNewAccount(_ account: Account) {
		if !accountExist(account: account) {
            tempAccounts.append(account)
        }
	}

	// MARK: - Private Methods

	private func getPrivateKeyOfFirstAccount(wallet: HDWallet) -> Data {
		let firstAccountIndex = UInt32(0)
		let changeConstant = UInt32(0)
		let addressIndex = UInt32(0)
		let privateKey = wallet.getDerivedKey(
			coin: .ethereum,
			account: firstAccountIndex,
			change: changeConstant,
			address: addressIndex
		)
		return privateKey.data
	}

	private func encryptHdWalletSeed(_ seed: Data, forAccount account: Account) -> Data {
		secureEnclave.encrypt(plainData: seed, withPublicKeyLabel: KeychainManager.seed.getKey(account: account))
	}

	private func decryptHdWalletSeed(fromEncryptedData encryptedSeed: Data, forAccount account: Account) -> Data {
		secureEnclave.decrypt(
			cipherData: encryptedSeed,
			withPublicKeyLabel: KeychainManager.seed.getKey(account: account)
		)
	}
}
