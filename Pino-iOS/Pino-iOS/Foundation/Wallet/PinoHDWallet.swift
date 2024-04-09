//
//  PinoHDWallet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import PromiseKit
import WalletCore

protocol PinoHDWalletType: PinoWallet {
	func createInitialHDWallet(mnemonics: String) -> Promise<Account>
	func createAccountIn(wallet: HDWallet, lastIndex: Int) throws -> Account
	func createHDWallet(mnemonics: String) -> Promise<HDWallet>
}

public class PinoHDWallet: PinoHDWalletType {
	// MARK: - Private Properties

	private var secureEnclave = SecureEnclave()

	// MARK: - Public Methods

	public func createInitialHDWallet(mnemonics: String) -> Promise<Account> {
		Promise<Account> { seal in
			firstly {
				createHDWallet(mnemonics: mnemonics)
			}.then { createdWallet in
				self.createInitialAccountIn(wallet: createdWallet).map { ($0, createdWallet) }
			}.done { createdAccount, createdWallet in
				let encryptedMnemonicsData = self.encryptHdWalletMnemonics(
					createdWallet.mnemonic,
					forAccount: createdAccount.eip55Address
				)
				if let error = KeychainManager.mnemonics.setValueWithKey(
					value: encryptedMnemonicsData,
					accountAddress: createdAccount.eip55Address
				) {
					seal.reject(error)
				}
				seal.fulfill(createdAccount)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func createInitialAccountIn(wallet: HDWallet) -> Promise<Account> {
		Promise<Account> { seal in
			let firstAccountPrivateKey = getPrivateKeyOfFirstAccount(wallet: wallet)
			let account = try Account(privateKeyData: firstAccountPrivateKey)
			let encryptedPrivateKeyData = encryptPrivateKey(firstAccountPrivateKey, forAccount: account.eip55Address)
			if let error = KeychainManager.privateKey.setValueWithKey(
				value: encryptedPrivateKeyData,
				accountAddress: account.eip55Address
			) {
				seal.reject(error)
			}
			seal.fulfill(account)
		}
	}

	public func createHDWallet(mnemonics: String) -> Promise<HDWallet> {
		Promise<HDWallet> { seal in
			guard WalletValidator.isMnemonicsValid(mnemonic: mnemonics) else {
				seal.reject(WalletOperationError.validator(.mnemonicIsInvalid))
				return
			}
			guard let wallet = HDWallet(mnemonic: mnemonics, passphrase: .emptyString) else {
				seal.reject(WalletOperationError.wallet(.walletCreationFailed))
				return
			}
			seal.fulfill(wallet)
		}
	}

	public func createHDWallet(with mnemonics: String, for accounts: [Account]) -> Promise<Void> {
		Promise<Void> { seal in
			firstly {
				createHDWallet(mnemonics: mnemonics)
			}.done { createdWallet in
				accounts.forEach { account in
					let encryptedPrivateKeyData = self.encryptPrivateKey(
						account.privateKey,
						forAccount: account.eip55Address
					)
					if let error = KeychainManager.privateKey.setValueWithKey(
						value: encryptedPrivateKeyData,
						accountAddress: account.eip55Address
					) {
						seal.reject(error)
					}

					let encryptedMnemonicsData = self.encryptHdWalletMnemonics(
						createdWallet.mnemonic,
						forAccount: account.eip55Address
					)
					if let error = KeychainManager.mnemonics.setValueWithKey(
						value: encryptedMnemonicsData,
						accountAddress: account.eip55Address
					) {
						seal.reject(error)
					}
				}
				seal.fulfill(())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func createAccountIn(wallet: HDWallet, lastIndex: Int) throws -> Account {
		let coinType = CoinType.ethereum
		let derivationPath = "m/44'/60'/0'/0/\(lastIndex)"
		let privateKey = wallet.getKey(coin: coinType, derivationPath: derivationPath)
		let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
		let account = try Account(privateKeyData: privateKey.data)
		account.derivationPath = derivationPath
		try saveEncryptedKeys(
			mnemonic: wallet.mnemonic,
			privateKey: privateKey.data,
			accountAddress: account.eip55Address
		)

		print("Private Key: \(privateKey.data.hexString)")
		print("Public Key: \(publicKey.data.hexString)")
		print("EIP Key: \(account.eip55Address)")
		print("Ethereum Address: \(account)")
		return account
	}

	public func createAccountIn(wallet: HDWallet, account: ActiveAccountViewModel) throws {
		let privateKey = wallet.getKey(coin: .ethereum, derivationPath: account.derivationPath)
		try saveEncryptedKeys(
			mnemonic: wallet.mnemonic,
			privateKey: privateKey.data,
			accountAddress: account.address
		)
	}

	public func saveEncryptedKeys(mnemonic: String, privateKey: Data, accountAddress: String) throws {
		// We save mnemonics with the prefix of account address in keychain
		// but since accounts can be deleted so will the keys to mnemonics
		// we need to save mnemonics with each created account address in case
		// of account removal another duplicate of mnemonics would still exist in keychain

		let encryptedMnemonicsData = encryptHdWalletMnemonics(mnemonic, forAccount: accountAddress)
		let encryptedPrivateKeyData = encryptPrivateKey(privateKey, forAccount: accountAddress)

		if let error = KeychainManager.mnemonics.setValueWithKey(
			value: encryptedMnemonicsData,
			accountAddress: accountAddress
		) {
			throw error
		}
		if let error = KeychainManager.privateKey.setValueWithKey(
			value: encryptedPrivateKeyData,
			accountAddress: accountAddress
		) {
			throw error
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

	private func encryptHdWalletMnemonics(_ mnemonics: String, forAccount address: String) -> Data {
		secureEnclave.encrypt(
			plainData: mnemonics.utf8Data,
			withPublicKeyLabel: KeychainManager.mnemonics.getKey(address)
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
}
