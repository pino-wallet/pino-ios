//
//  ValidateSecratPhraseVM.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

class ValidateSecretPhraseVM {
	private var onSuccess: () -> Void
	private var onFailure: (ValidationError) -> Void

	init(onSuccess: @escaping () -> Void, onFailure: @escaping (ValidationError) -> Void) {
		self.onSuccess = onSuccess
		self.onFailure = onFailure
	}

	func validateSeedPhrase(secretPhrase: [String]) {
		let intersction = Array(Set(secretPhrase).intersection(HDWallet.englishWordList))
		if intersction.count == secretPhrase.count {
			onSuccess()
		} else {
			onFailure(.invalidSecretPhrase)
		}
	}
}
