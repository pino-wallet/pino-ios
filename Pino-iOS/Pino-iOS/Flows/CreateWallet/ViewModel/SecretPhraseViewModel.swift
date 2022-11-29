//
//  SecretPhraseVM.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

import Foundation
import WalletCore

class SecretPhraseViewModel {
	// MARK: public Properties

	private let emptyPassphrase = ""
	public var secretPhrase: [String] = []

	// MARK: Initializers

	init() {
		generateMnemonic()
	}

	// MARK: Method

	private func generateMnemonic() {
		let seedPhraseCount: HDWallet.SeedPhraseCount = .word12
		if let newHdWallet = HDWallet(strength: seedPhraseCount.strength, passphrase: emptyPassphrase) {
			let mnemonic = newHdWallet.mnemonic
			secretPhrase = mnemonic.byWords
		}
	}
}
