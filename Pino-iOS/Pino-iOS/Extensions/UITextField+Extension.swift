//
//  UITextField+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import UIKit

extension UITextField {
	public func enteredNumberPatternIsValid(charactersRange: NSRange, replacementString: String) -> Bool {
		guard let currentText = text as NSString? else {
			return true
		}

		let updatedText = currentText.replacingCharacters(in: charactersRange, with: replacementString)
		return validatePatternWithRegex(
			regexPattern: "^((?!0[1-9]+)(?!.*[.,].*[.,])([0-9]+)[.,]?([0-9]*))?$|^0[.,]([0-9]+)?$",
			updatedText: updatedText
		)
	}

	public func enteredInviteCodePatternIsValid(charactersRange: NSRange, replacementString: String) -> Bool {
		guard let currentText = text as NSString? else {
			return true
		}

		let updatedText = currentText.replacingCharacters(in: charactersRange, with: replacementString)
		return validatePatternWithRegex(regexPattern: "^[a-zA-Z0-9]*$", updatedText: updatedText)
	}
}

fileprivate func validatePatternWithRegex(regexPattern: String, updatedText: String) -> Bool {
	let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
	let range = NSRange(location: 0, length: updatedText.utf16.count)
	let isMatch = regex?.firstMatch(in: updatedText, options: [], range: range) != nil

	return isMatch
}
