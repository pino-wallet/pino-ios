//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

struct ValidateSecretPhraseViewModel {
	// MARK: Public Properties

	public let title = "Verify secret phrase"
	public let description = "Please select each word in the correct order to verify you have saved your Secret Phrase."
	public let errorTitle = "Invalid Secret Phrase"
	public let continueButtonTitle = "Continue"
	public var maxSeedPhraseCount = HDWallet.validSeedPhraseCounts[0]

	// MARK: Public Methods

	public func validate(
		secretPhrase: [String],
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (SecretPhraseValidationError) -> Void
	) {
		let intersction = Array(Set(secretPhrase).intersection(HDWallet.englishWordList))
		if intersction.count == secretPhrase.count {
			onSuccess()
		} else {
			onFailure(.invalidSecretPhrase)
		}
	}
}
