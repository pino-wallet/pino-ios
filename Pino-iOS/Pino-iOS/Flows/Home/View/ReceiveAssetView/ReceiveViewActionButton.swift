//
//  ReceiveViewActionButton.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

import UIKit

class ReceiveViewActionButton: UIStackView {
	// MARK: - Public Properties

	public var iconName: String {
		didSet {
			iconView.image = UIImage(named: iconName)
		}
	}

	public var titleText: String {
		didSet {
			titleLabel.text = titleText
		}
	}

	public var onTap: () -> Void

	// MARK: - Private Properties

	private let iconView = UIImageView()
	private let titleLabel = PinoLabel(style: .receiveButtonActionTitle, text: "")

	// MARK: - Initializers

	init(iconName: String = "", titleText: String = "", onTap: @escaping () -> Void = {}) {
		self.iconName = iconName
		self.titleText = titleText
		self.onTap = onTap
		super.init(frame: .zero)
		setupView()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onGestureTap))
		addGestureRecognizer(tapGesture)
		axis = .vertical
		alignment = .center
		spacing = 8

		addArrangedSubview(iconView)
		addArrangedSubview(titleLabel)
		titleLabel.textAlignment = .center
	}

	@objc
	private func onGestureTap() {
		onTap()
	}
}

extension PinoLabel.Style {
	fileprivate static let receiveButtonActionTitle = PinoLabel.Style(
		textColor: .Pino.primary,
		font: .PinoStyle.mediumSubheadline,
		numberOfLine: 0,
		lineSpacing: 6
	)
}
