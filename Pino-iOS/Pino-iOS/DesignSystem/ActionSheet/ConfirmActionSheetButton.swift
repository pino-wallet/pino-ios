//
//  ConfirmActionSheetButton.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/27/23.
//

import UIKit

class ConfirmActionSheetButton: UIButton {
	// MARK: - Closure

	public var dismissActionsheetClosure: (() -> Void)!

	// MARK: - Public Properties

	public var title: String
	public var font: UIFont
	public var titleColor: UIColor
	public var handler: () -> Void

	// MARK: - Private Properties

	private var borderTop: UIView!

	// MARK: - Initializers

	init(title: String, font: UIFont, titleColor: UIColor, handler: @escaping () -> Void) {
		self.title = title
		self.font = font
		self.titleColor = titleColor
		self.handler = handler
		super.init(frame: .zero)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private Methods

	private func setupView() {
		setTitle(title, for: .normal)
		setTitleColor(titleColor, for: .normal)
		addTarget(self, action: #selector(onTap), for: .touchUpInside)
		setConfiguraton(font: font, titlePadding: 16)

		borderTop = UIView()
		borderTop.backgroundColor = UIColor.Pino.gray2
		addSubview(borderTop)
	}

	private func setupConstraints() {
		heightAnchor.constraint(greaterThanOrEqualToConstant: 61).isActive = true
		borderTop.pin(.fixedHeight(0.3), .horizontalEdges(padding: 0))
	}

	@objc
	private func onTap() {
		handler()
		dismissActionsheetClosure()
	}
}
