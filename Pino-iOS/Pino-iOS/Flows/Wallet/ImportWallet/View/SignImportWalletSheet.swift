//
//  SwapFeeInfoSheet.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/6/23.
//

import UIKit

class SignImportWalletSheet: UIAlertController {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleIcon = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descLabel = PinoLabel(style: .description, text: nil)
	private var titleText: String!
	private var descriptionText: String!

	private let actionButton = PinoButton(style: .active)

	// MARK: - Public Properties

	public var actionButtonTitle = "Sign"
	public var onActionButtonTap: (() -> Void)?

	// MARK: - Initializers

	convenience init(title: String, description: String) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)

		self.titleText = title
		self.descriptionText = description

		setupView()
		setupStyle()
		setupConstraint()
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(actionButton)
		titleStackView.addArrangedSubview(titleIcon)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descLabel)

		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle() {
		titleLabel.text = titleText
		descLabel.text = descriptionText
		actionButton.title = actionButtonTitle

		titleIcon.image = UIImage(named: "sign-key-icon")
		titleIcon.contentMode = .scaleAspectFit

		titleLabel.numberOfLines = 2
		descLabel.numberOfLines = 2
		titleLabel.textAlignment = .center
		descLabel.textAlignment = .center

		contentView.backgroundColor = .Pino.secondaryBackground
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical

		titleStackView.axis = .vertical

		contentStackView.spacing = 32
		titleStackView.spacing = 16

		actionButton.addAction(UIAction(handler: { _ in
			if let onButtonTap = self.onActionButtonTap {
				onButtonTap()
			} else {
				self.dismiss(animated: true)
			}
		}), for: .touchUpInside)
	}

	private func setupConstraint() {
		titleIcon.pin(
			.fixedWidth(64),
			.fixedHeight(64)
		)
		actionButton.pin(
			.horizontalEdges(),
			.fixedHeight(56)
		)
		contentStackView.pin(
			.allEdges(padding: 16)
		)
		contentView.pin(
			.allEdges
		)
		titleIcon.pin(
			.fixedWidth(64),
			.fixedHeight(64)
		)
	}
}
