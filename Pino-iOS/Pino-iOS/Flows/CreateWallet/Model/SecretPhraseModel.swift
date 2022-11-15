//
//  SeedPhraseModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//

public struct SeedPhrase {
	// MARK: Public Properties

	public let title: String
	public let sequence: Int

	// MARK: Initializers

	init(title: String, sequence: Int) {
		self.title = title
		self.sequence = sequence
	}
}
