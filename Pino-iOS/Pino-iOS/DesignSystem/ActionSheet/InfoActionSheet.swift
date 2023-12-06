//
//  InfoActionSheet.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/22/23.
//

import UIKit

class InfoActionSheet: UIAlertController {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let titleIcon = UIImageView()
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let actionButton = PinoButton(style: .active)

	// MARK: - Public Properties

	public var actionButtonTitle = "Got it"
	public var onActionButtonTap: (() -> Void)?

	// MARK: - Initializers

	convenience init(title: String, description: String) {
        self.init(title: "", message: nil, preferredStyle: .actionSheet)

		setupView()
		setupStyle(title: title, description: description)
		setupConstraint()
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(descriptionLabel)
		contentStackView.addArrangedSubview(actionButton)
		titleStackView.addArrangedSubview(titleIcon)
		titleStackView.addArrangedSubview(titleLabel)
		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle(title: String, description: String) {
		titleLabel.text = title
		descriptionLabel.text = description
		actionButton.title = actionButtonTitle
		titleIcon.image = UIImage(named: "info")
		titleIcon.tintColor = .Pino.primary

		contentView.backgroundColor = .Pino.secondaryBackground
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical
		titleStackView.axis = .horizontal

		contentStackView.spacing = 24
		titleStackView.spacing = 6

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
			.fixedWidth(20),
			.fixedHeight(20)
		)
		actionButton.pin(
			.fixedWidth(300)
		)
		contentStackView.pin(
			.allEdges(padding: 16)
		)
		contentView.pin(
			.allEdges
		)
	}
}
