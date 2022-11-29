//
//  ValidateSecratPhraseViewModel.swift
//  Pino-iOS
//
//  Created by MohammadHossein on 11/29/22.
//

import Foundation

class ValidateSecratPhrase {
	private let secratPharse: [String]

	init(secratPharse: [String]) {
		self.secratPharse = secratPharse
	}

	func isContiansSeed(secratPhrase: [String]) -> Bool {
		let intersction = Array(Set(secratPhrase).intersection(HDWallet.englishWordList))
		if intersction.count == secratPhrase.count {
			return true
		} else {
			return false
		}
	}
}
