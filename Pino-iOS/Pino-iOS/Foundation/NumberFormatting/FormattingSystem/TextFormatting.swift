//
//  TextFormatting.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 7/13/23.
//

import Foundation

protocol TextFormattingSystem {
	var currencyFormatting: String { get }
	var ethFormatting: String { get }
	var percentFormatting: String { get }
}

extension TextFormattingSystem {
	// MARK: - Public Properties

	public var currencyFormatting: String {
		preWordFormatting(char: currentCurrency)
	}

	public var ethFormatting: String {
		tokenFormatting(token: "ETH")
	}

	public var percentFormatting: String {
		preWordFormatting(char: "%")
	}

	private var currentCurrency: String {
		"$"
	}

	// MARK: - Private Methods

	private func preWordFormatting(char: String) -> String {
		"\(char)\(self)"
	}

	public func tokenFormatting(token: String) -> String {
		"\(self) \(token)"
	}
}

extension String: TextFormattingSystem {}
extension Double: TextFormattingSystem {}
