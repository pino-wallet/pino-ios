//
//  PinoFont.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

// MARK: - UIFont.PinoStyle

extension UIFont {
	// MARK: Custom Font

	struct PinoStyle {
		// MARK: Font Attributes

		public let fontName: FontName
		public let fontSize: FontSize
	}
}

extension UIFont.PinoStyle {
	enum FontName: String {
		case pinoBold = "PPPangramSans-Bold"
		case pinoSemibold = "PPPangramSans-Semibold"
		case pinoMedium = "PPPangramSans-Medium"
		case pinoRegular = "PPPangramSans-Regular"
		case pinoLight = "PPPangramSans-Light"
		case pinoThin = "PPPangramSans-Thin"
	}

	enum FontSize: CGFloat {
		case largeTitle = 36
		case title1 = 28
		case title2 = 22
        case title3 = 20
		case headline, body = 17
		case callout = 16
		case subHeadline = 15
		case footnote = 13
		case caption1 = 12
		case caption2 = 11
	}
}
