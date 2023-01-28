//
//  InfoActionSheet.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/22/23.
//

import UIKit

class InfoActionSheet: UIAlertController {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let titleIcon = UIImageView()
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let actionButton = PinoButton(style: .active)

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
		view.addSubview(contentStackView)
	}

	private func setupStyle(title: String, description: String) {
		titleLabel.text = title
		descriptionLabel.text = description
		actionButton.title = "Got it"
		titleIcon.image = UIImage(systemName: "info.circle.fill")
		titleIcon.tintColor = .Pino.primary

		contentStackView.axis = .vertical
		titleStackView.axis = .horizontal

		contentStackView.spacing = 24
		titleStackView.spacing = 6

		actionButton.addAction(UIAction(handler: { _ in
			self.dismiss(animated: true)
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
	}
}
