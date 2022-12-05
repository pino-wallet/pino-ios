//
//  SecretPhraseVM.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

import Foundation
import WalletCore

class SecretPhraseViewModel {
	// MARK: Public Properties

	public var secretPhrase: [String] = []

	// MARK: - Privare Properties

	private let emptyPassphrase = ""

	// MARK: Initializers

	init() {
		generateMnemonic()
	}

	// MARK: - Private Methods

	private func generateMnemonic() {
		let seedPhraseCount: HDWallet.SeedPhraseCount = .word12
		if let newHdWallet = HDWallet(strength: seedPhraseCount.strength, passphrase: emptyPassphrase) {
			let mnemonic = newHdWallet.mnemonic
			secretPhrase = mnemonic.toArray
        } else {
            fatalError("ganerate mnemonic faild.")
        }
	}
}
