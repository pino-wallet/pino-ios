//
//  UITextField+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/26/23.
//

import UIKit

extension UITextField {
	public func isNumber(charactersRange: NSRange, replacementString: String) -> Bool {
		guard let currentText = text as NSString? else {
			return true
		}

		let updatedText = currentText.replacingCharacters(in: charactersRange, with: replacementString)
		return validatePatternWithRegex(
			regexPattern: "^((?!0[1-9]+)(?!.*[.,].*[.,])([0-9]+)[.,]?([0-9]*))?$|^0[.,]([0-9]+)?$",
			updatedText: updatedText
		)
	}

	public func isAlphaNumeric(charactersRange: NSRange, replacementString: String) -> Bool {
		guard let currentText = text as NSString? else {
			return true
		}

		let updatedText = currentText.replacingCharacters(in: charactersRange, with: replacementString)
		return validatePatternWithRegex(regexPattern: "^[a-zA-Z0-9]*$", updatedText: updatedText)
	}

	func moveCursorToBeginning(textfieldWidth: CGFloat) {
		guard let textFieldText = text else { return }
		let textAttributes = [NSAttributedString.Key.font: font!]
		let textWidth = textFieldText.size(withAttributes: textAttributes).width

		if textWidth > textfieldWidth {
			// Move the cursor to the beginning
			DispatchQueue.main.async {
				let beginning = self.self.beginningOfDocument
				self.selectedTextRange = self.self.textRange(from: beginning, to: beginning)
			}
		}
	}
}

fileprivate func validatePatternWithRegex(regexPattern: String, updatedText: String) -> Bool {
	let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
	let range = NSRange(location: 0, length: updatedText.utf16.count)
	let isMatch = regex?.firstMatch(in: updatedText, options: [], range: range) != nil

	return isMatch
}
