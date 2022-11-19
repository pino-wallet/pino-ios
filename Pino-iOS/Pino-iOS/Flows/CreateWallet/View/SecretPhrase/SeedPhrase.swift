//
//  SecretPhrase.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import Foundation

public protocol SeedPhrase {
	var style: SecretPhraseCell.Style { get }
	var sequence: Int? { get set }
	var title: String? { get set }
}

struct DefaultSeedPhrase: SeedPhrase {
	var style = SecretPhraseCell.Style.regular
	var sequence: Int?
	var title: String?

	init(sequence: Int, title: String) {
		self.sequence = sequence
		self.title = title
	}
}

struct UnorderedSeedPhrase: SeedPhrase {
	var style = SecretPhraseCell.Style.unordered
	var sequence: Int?
	var title: String?

	init(title: String) {
		self.sequence = nil
		self.title = title
	}
}

struct EmptySeedPhrase: SeedPhrase {
	var style = SecretPhraseCell.Style.empty
	var sequence: Int?
	var title: String?

	init() {
		self.sequence = nil
		self.title = nil
	}
}
