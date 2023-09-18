//
//  TitleAndInfoStackView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import UIKit

class LoanDetailsInfoStackView: UIStackView {
	// MARK: - Private Properties

	private let spacerView = UIView()
	private var titleText: String
	private var infoText: String

	// MARK: - Public PRoperties

	public let titleLabel = PinoLabel(style: .info, text: "")
	public let infoLabel = PinoLabel(style: .info, text: "")

	// MARK: - Initializers

	init(titleText: String, infoText: String) {
		self.titleText = titleText
		self.infoText = infoText

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addArrangedSubview(titleLabel)
		addArrangedSubview(spacerView)
		addArrangedSubview(infoLabel)
	}

	private func setupStyles() {
		axis = .horizontal
		alignment = .center

		infoLabel.font = .PinoStyle.mediumBody
		infoLabel.text = infoText
		infoLabel.numberOfLines = 0

		titleLabel.text = titleText
		titleLabel.textColor = .Pino.secondaryLabel
		titleLabel.numberOfLines = 0
	}

	private func setupConstraints() {
		heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
		infoLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
	}
}
