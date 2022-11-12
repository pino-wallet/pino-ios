//
//  PinoCheckBox.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public class PinoCheckBox: UIButton {
	// MARK: Lifecycle

	// MARK: - Initializers

	public init(style: Style = .defaultStyle) {
		self.style = style
		super.init(frame: .zero)
		addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
		updateUI(isChecked: false)
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Public

	// MARK: - Public properties

	public var style: Style

	// MARK: - UI overrides

	override public func awakeFromNib() {
		addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
		updateUI(isChecked: false)
	}

	// MARK: Internal

	@objc
	func buttonClicked() {
		isChecked.toggle()
	}

	// MARK: Private

	// MARK: - private properties

	private var isChecked = false {
		didSet {
			updateUI(isChecked: isChecked)
		}
	}

	// MARK: - Private methods

	private func updateUI(isChecked: Bool) {
		let checkBoxIcon: UIImage?
		let checkBoxTintColor: UIColor?
		if isChecked {
			checkBoxIcon = style.checkedImage
			checkBoxTintColor = style.checkedTintColor
		} else {
			checkBoxIcon = style.uncheckedImage
			checkBoxTintColor = style.unchekedTintColor
		}
		setImage(checkBoxIcon, for: .normal)
		tintColor = checkBoxTintColor
	}
}
