//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

struct ValidateSecretPhraseViewModel {
	// MARK: PrivateProperties

	private var onSuccess: () -> Void
	private var onFailure: (SecretPhraseValidationError) -> Void

    // MARK: Public Properties
    public var maxSeedPhraseCount = HDWallet.validSeedPhraseCounts[0]
	// MARK: Initializers

	init(onSuccess: @escaping () -> Void, onFailure: @escaping (SecretPhraseValidationError) -> Void) {
		self.onSuccess = onSuccess
		self.onFailure = onFailure
	}

	// MARK: Public Methods
	public func validate(secretPhrase: [String]) {
		let intersction = Array(Set(secretPhrase).intersection(HDWallet.englishWordList))
		if intersction.count == secretPhrase.count {
			onSuccess()
		} else {
			onFailure(.invalidSecretPhrase)
		}
	}
}
