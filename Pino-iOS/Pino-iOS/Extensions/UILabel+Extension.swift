//
//  UILabel+Extension.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/6/24.
//

import Foundation
import UIKit

extension UILabel {
	public func setFootnoteText(wholeString: String, boldString: String, boldRangeIndex: Int = 0) {
		let normalAttrs = [
			NSAttributedString.Key.font: UIFont.PinoStyle.mediumFootnote,
			NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel,
		]
		let boldAttrs = [
			NSAttributedString.Key.font: UIFont.PinoStyle.semiboldFootnote,
			NSAttributedString.Key.foregroundColor: UIColor.Pino.secondaryLabel,
		]

		let resultAttributedString = NSMutableAttributedString(
			string: wholeString,
			attributes: normalAttrs as [NSAttributedString.Key: Any]
		)

		let findStringRegexPattern = "\\b\(boldString)\\b"

		guard let findStringRegex = try? NSRegularExpression(pattern: findStringRegexPattern, options: []) else {
			fatalError("Invalid regular expression pattern")
		}

		let boldStringsMatches = findStringRegex.matches(
			in: resultAttributedString.string,
			options: [],
			range: NSRange(location: 0, length: resultAttributedString.string.utf16.count)
		)

		let boldStringRanges = boldStringsMatches.map { $0.range }

		resultAttributedString.addAttributes(
			boldAttrs as [NSAttributedString.Key: Any],
			range: boldStringRanges[boldRangeIndex]
		)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 6
		paragraphStyle.alignment = .center
		resultAttributedString.addAttribute(
			.paragraphStyle,
			value: paragraphStyle,
			range: NSRange(location: 0, length: resultAttributedString.length)
		)

		attributedText = resultAttributedString
		numberOfLines = 0
	}
}
