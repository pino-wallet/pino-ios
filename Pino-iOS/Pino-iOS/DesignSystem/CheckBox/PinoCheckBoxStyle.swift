//
//  PinoCheckBoxStyle.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

// MARK: - PinoCheckBox Style

extension PinoCheckBox {
	/// Specifies a visual theme of the checkBox
	public struct Style: Equatable {
		public let uncheckedImage: UIImage?
		public let checkedImage: UIImage?
		public let unchekedTintColor: UIColor
		public let checkedTintColor: UIColor
	}
}

// MARK: - Custom CheckBox Styles

extension PinoCheckBox.Style {
	public static let defaultStyle = PinoCheckBox.Style(
		uncheckedImage: UIImage(
			systemName: "square",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 26)
		),
		checkedImage: UIImage(
			systemName: "checkmark.square.fill",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 26)
		),
		unchekedTintColor: .Pino.gray3,
		checkedTintColor: .Pino.primary
	)

	public static let deactive = PinoCheckBox.Style(
		uncheckedImage: UIImage(
			systemName: "checkmark.square",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 26)
		),
		checkedImage: UIImage(
			systemName: "checkmark.square.fill",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 26)
		),
		unchekedTintColor: .Pino.gray3,
		checkedTintColor: .Pino.primary
	)
}
