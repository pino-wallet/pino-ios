//
//  WalletValidator.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/25/23.
//

import Foundation
import WalletCore

public enum WalletValidator {
	public static func isPrivateKeyValid(key: String) -> Bool {
		if let keyData = Data(hexString: key.trimmingCharacters(in: .whitespacesAndNewlines)) {
			return PrivateKey.isValid(data: keyData, curve: .secp256k1)
		} else {
			return false
		}
	}

	public static func isPrivateKeyValid(key: Data) -> Bool {
		PrivateKey.isValid(data: key, curve: .secp256k1)
	}

	public static func isPublicKeyValid(key: Data) -> Bool {
		PublicKey.isValid(data: key, type: .secp256k1)
	}

	public static func isMnemonicsValid(mnemonic: String) -> Bool {
		Mnemonic.isValid(mnemonic: mnemonic)
	}

	public static func isMnemonicsValid(mnemonic: [String]) -> Bool {
		Mnemonic.isValid(mnemonic: mnemonic.joined())
	}

	public static func isEthAddressValid(address: String) -> Bool {
		AnyAddress.isValid(string: address, coin: .ethereum)
	}
}
