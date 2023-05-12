//
//  Account.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore
import Web3Core

public struct Account: Codable {
	public enum AccountSource: Int32, Codable {
		case hdWallet = 0
		case nonHDWallet
	}

	public var address: EthereumAddress
	public var isActiveAccount: Bool
	/// For Accounts derived from HDWallet
	public var derivationPath: String?
	public var publicKey: Data
	public var accountSource: AccountSource

	public var eip55Address: String {
		address.address
	}

	init(address: String, derivationPath: String? = nil, publicKey: Data) throws {
		guard let address = EthereumAddress(address) else { throw WalletValidatorError.addressIsInvalid }
		self.address = address
		self.isActiveAccount = true
		self.derivationPath = derivationPath
		self.publicKey = publicKey
		self.accountSource = .hdWallet
	}

	init(privateKeyData: Data, accountSource: AccountSource = .hdWallet) throws {
		guard WalletValidator.isPrivateKeyValid(key: privateKeyData)
		else { throw WalletOperationError.validator(.privateKeyIsInvalid) }
		let privateKey = PrivateKey(data: privateKeyData)!
		let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
		guard WalletValidator.isPublicKeyValid(key: publicKey.data) else {
			throw WalletOperationError.validator(.publicKeyIsInvalid)
		}
		guard let address = Utilities.publicToAddress(publicKey.data) else {
			throw WalletOperationError.validator(.addressIsInvalid)
		}
		self.derivationPath = nil
		self.publicKey = publicKey.data
		self.address = address
		self.isActiveAccount = true
		self.accountSource = accountSource
	}

	init(publicKey: Data, accountSource: AccountSource = .hdWallet) throws {
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
		self.accountSource = accountSource
	}
    
    init(account: WalletAccount) {
        self.derivationPath = account.derivationPath
        self.publicKey = account.publicKey
        self.address = EthereumAddress(account.eip55Address)!
        self.isActiveAccount = account.isSelected
        self.accountSource = account.source.accountSource
    }
}

extension Account: Equatable {
	public static func == (lhs: Account, rhs: Account) -> Bool {
		lhs.address == rhs.address
	}
}
