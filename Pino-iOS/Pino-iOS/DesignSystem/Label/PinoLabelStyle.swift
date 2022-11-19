//
//  PinoLabelStyle.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/17/22.
//

import UIKit

// MARK: - PinoLabel Style

extension PinoLabel {
	// Specifies a visual theme of the label
	public struct Style: Equatable {
		public let textColor: UIColor
		public let font: UIFont
		public let numberOfLine: Int
	}
}

// MARK: - Custom Label Styles

extension PinoLabel.Style {
	public static let title = PinoLabel.Style(
		textColor: .label,
		font: .PinoStyle.semiboldTitle3!,
		numberOfLine: 1
	)

	public static let description = PinoLabel.Style(
		textColor: .secondaryLabel,
		font: .PinoStyle.mediumCallout!,
		numberOfLine: 0
	)
}
