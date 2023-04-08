//
//  Pass.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/24/22.
//

import Foundation

protocol PasscodeManagerPages {
	var title: String { get }
	var description: String? { get }
	var passcode: String? { get set }
	var passDigitsCount: Int { get }
	mutating func passInserted(passChar: String) // Added new pass number
	mutating func passRemoved() // Cleared last pass number
}

extension PasscodeManagerPages {
	var passDigitsCount: Int { 6 } // Default number of Password digits count

	mutating func passRemoved() {
		_ = passcode?.popLast()
	}
}
