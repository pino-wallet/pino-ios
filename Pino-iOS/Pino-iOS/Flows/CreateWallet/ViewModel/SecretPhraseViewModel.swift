//
//  SecretPhraseVM.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

import Foundation

class SecretPhraseViewModel {
	// MARK: public Properties

	public var secretPhrase: [SeedPhrase] = []

	// MARK: Initializers

	init() {
		getRandomWords(numberOfWords: 12)
	}

	// MARK: Public Methods

	public func getRandomWords(numberOfWords: Int) {
		// This should be replaced by the library words list
		let shuffledList = MockSeedPhrase.wordList.shuffled()
		let secretPhraseWordsList = Array(shuffledList.prefix(numberOfWords))

		secretPhrase = secretPhraseWordsList.enumerated().map { index, element in
			SeedPhrase(title: element, sequence: index + 1)
		}
	}
}
