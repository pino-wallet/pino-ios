//
//  ProvidersViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import UIKit

class ProvidersViewcontroller: UIAlertController {
	// MARK: - Private Properties

	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let closePageButton = PinoButton(style: .active)

	private var providerDidSelect: ((SwapProviderModel) -> Void)!

	// MARK: - Initializers

	convenience init(providerDidSelect: @escaping (SwapProviderModel) -> Void) {
		self.init(title: "", message: nil, preferredStyle: .actionSheet)

		self.providerDidSelect = providerDidSelect

		setupView()
		setupStyle()
		setupConstraint()
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(closePageButton)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		contentView.addSubview(contentStackView)
		view.addSubview(contentView)
	}

	private func setupStyle() {
		titleLabel.text = "title"
		descriptionLabel.text = "description"
		closePageButton.title = "Got it"

		contentView.backgroundColor = .Pino.secondaryBackground
		contentView.layer.cornerRadius = 12
		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackView.spacing = 24
		titleStackView.spacing = 5

		closePageButton.addAction(UIAction(handler: { _ in
			self.dismiss(animated: true)
		}), for: .touchUpInside)
	}

	private func setupConstraint() {
		contentStackView.pin(
			.allEdges(padding: 16)
		)
		contentView.pin(
			.allEdges
		)
	}
}
