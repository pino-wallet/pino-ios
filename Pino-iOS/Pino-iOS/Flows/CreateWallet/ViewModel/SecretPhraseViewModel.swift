//
//  SecretPhraseVM.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

import Foundation

class SecretPhraseViewModel {
	var secretPhrase: [SeedPhrase] = []

	init() {
		getRandomWords(numberOfWords: 12)
	}

	public func getRandomWords(numberOfWords: Int) {
		// This should be replaced by the library words list
		let shuffledList = MockSeedPhrase.wordList.shuffled()
		let secretPhraseWordsList = Array(shuffledList.prefix(numberOfWords))

		secretPhrase = secretPhraseWordsList.enumerated().map { index, element in
			SeedPhrase(title: element, sequence: String(index + 1))
		}
	}
}
