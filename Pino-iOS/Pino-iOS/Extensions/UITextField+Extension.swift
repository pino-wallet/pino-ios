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
		let pattern = "^(?!\\.)(?!.*\\..*\\.)([0-9]*)\\.?([0-9]*)$"
		let regex = try? NSRegularExpression(pattern: pattern, options: [])
		let range = NSRange(location: 0, length: updatedText.count)
		let isMatch = regex?.firstMatch(in: updatedText, options: [], range: range) != nil

		return isMatch
	}
}
