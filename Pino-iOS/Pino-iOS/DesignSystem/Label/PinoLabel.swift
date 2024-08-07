//
//  PinoLabel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/17/22.
//

import UIKit

public class PinoLabel: UILabel {
	// MARK: - Public properties

	public var style: Style {
		didSet {
			updateStyle()
		}
	}

	override public var text: String? {
		didSet {
			setLineSpacing()
		}
	}

	// MARK: - Initializers

	public init(style: Style, text: String?) {
		self.style = style
		super.init(frame: .zero)
		self.text = text
		updateStyle()
	}

	public required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - UILabel overrides

	override public func layoutSubviews() {
		super.layoutSubviews()
	}

	// MARK: - Private methods

	private func updateStyle() {
		textColor = style.textColor
		font = style.font
		numberOfLines = style.numberOfLine
		setLineSpacing()
	}

	private func setLineSpacing() {
		guard let text = text else { return }
		let attributedString = NSMutableAttributedString(string: text)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = style.lineSpacing
		attributedString.addAttribute(
			.paragraphStyle,
			value: paragraphStyle,
			range: NSRange(location: 0, length: attributedString.length)
		)
		attributedText = attributedString
	}
}
