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
	func createAccountIn(wallet: HDWallet, lastIndex: Int) throws -> Account
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

			let encryptedMnemonicsData = encryptHdWalletMnemonics(wallet.mnemonic, forAccount: account)
			let encryptedPrivateKeyData = encryptPrivateKey(firstAccountPrivateKey, forAccount: account)

			if let error = saveCredsInKeychain(
				keychainManagerType: KeychainManager.mnemonics,
				data: encryptedMnemonicsData,
				key: account.eip55Address
			) {
				return .failure(error)
			}
			if let error = saveCredsInKeychain(
				keychainManagerType: KeychainManager.privateKey,
				data: encryptedPrivateKeyData,
				key: account.eip55Address
			) {
				return .failure(error)
			}

			if accountExist(account: account) {
				return .success(wallet)
			} else {
				let coreDataWallet = createWalletInCoreData(type: .hdWallet)
				let _ = createWalletInCoreData(type: .nonHDWallet)
				addNewAccount(account, wallet: coreDataWallet)
				return .success(wallet)
			}
		} catch let error where error is WalletOperationError {
			return .failure(error as! WalletOperationError)
		} catch {
			return .failure(.wallet(.unknownError))
		}
	}

	public func createAccountIn(wallet: HDWallet, lastIndex: Int) throws -> Account {
		let coinType = CoinType.ethereum
		let derivationPath = "m/44'/60'/0'/0/\(lastIndex + 1)"
		let privateKey = wallet.getKey(coin: coinType, derivationPath: derivationPath)
		let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
		var account = try Account(publicKey: publicKey.data)
		account.derivationPath = derivationPath

		let encryptedMnemonicsData = encryptHdWalletMnemonics(wallet.mnemonic, forAccount: account)
		let encryptedPrivateKeyData = encryptPrivateKey(privateKey.data, forAccount: account)

		if let error = saveCredsInKeychain(
			keychainManagerType: KeychainManager.mnemonics,
			data: encryptedMnemonicsData,
			key: account.eip55Address
		) {
			throw error
		}
		if let error = saveCredsInKeychain(
			keychainManagerType: KeychainManager.privateKey,
			data: encryptedPrivateKeyData,
			key: account.eip55Address
		) {
			throw error
		}

		print("Private Key: \(privateKey.data.hexString)")
		print("Public Key: \(publicKey.data.hexString)")
		print("Ethereum Address: \(account)")
		return account
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

	private func encryptHdWalletMnemonics(_ mnemonics: String, forAccount account: Account) -> Data {
		secureEnclave.encrypt(
			plainData: mnemonics.utf8Data,
			withPublicKeyLabel: KeychainManager.mnemonics.getKey(account.eip55Address)
		)
	}

	private func decryptHdWalletMnemonics(
		fromEncryptedData encryptedMnemonics: Data,
		forAccount account: Account
	) -> Data {
		secureEnclave.decrypt(
			cipherData: encryptedMnemonics,
			withPublicKeyLabel: KeychainManager.mnemonics.getKey(account.eip55Address)
		)
	}

	private func createWalletInCoreData(type: Wallet.WalletType) -> Wallet {
		let coreDataManager = CoreDataManager()
		let newWallet = coreDataManager.createWallet(type: type)
		return newWallet
	}
}
