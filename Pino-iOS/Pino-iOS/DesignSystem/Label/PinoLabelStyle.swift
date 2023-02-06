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
	public struct Style {
		public let textColor: UIColor
		public let font: UIFont?
		public let numberOfLine: Int
		public let lineSpacing: CGFloat
	}
}

// MARK: - Custom Label Styles

extension PinoLabel.Style {
	public static let title = PinoLabel.Style(
		textColor: .Pino.label,
		font: .PinoStyle.semiboldTitle3,
		numberOfLine: 1,
		lineSpacing: 8
	)

	public static let description = PinoLabel.Style(
		textColor: .Pino.secondaryLabel,
		font: .PinoStyle.mediumCallout,
		numberOfLine: 0,
		lineSpacing: 6
	)

	public static let info = PinoLabel.Style(
		textColor: .Pino.label,
		font: .PinoStyle.mediumBody,
		numberOfLine: 1,
		lineSpacing: 0
	)
}
