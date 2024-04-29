//
//  EmptyStateCardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/26/23.
//

import Foundation
import UIKit

public class EmptyStateCardView: UIView {
	// MARK: - Closures

	public var onActionButtonTap: () -> Void = {}

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let mainStackView = UIStackView()
	private let textStackView = UIStackView()
	private let titleImageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let actionButton = PinoButton(style: .active)
	private let hapticManager = HapticManager()

	private var emptyStateCardViewproperties: EmptyStateCardViewProperties

	// MARK: - Initializers

	init(properties: EmptyStateCardViewProperties) {
		self.emptyStateCardViewproperties = properties

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionLabel)

		mainStackView.addArrangedSubview(titleImageView)
		mainStackView.addArrangedSubview(textStackView)
		mainStackView.addArrangedSubview(actionButton)

		containerView.addSubview(mainStackView)

		addSubview(containerView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.alignment = .center

		textStackView.axis = .vertical
		textStackView.spacing = 8
		textStackView.alignment = .center

		titleLabel.font = .PinoStyle.semiboldTitle2
		titleLabel.text = emptyStateCardViewproperties.title

		descriptionLabel.font = .PinoStyle.mediumBody
		descriptionLabel.text = emptyStateCardViewproperties.description
		descriptionLabel.textAlignment = .center

		actionButton.title = emptyStateCardViewproperties.buttonTitle

		titleImageView.image = UIImage(named: emptyStateCardViewproperties.imageName)
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true

		containerView.pin(.allEdges(padding: 0))
		mainStackView.pin(.verticalEdges(padding: 24), .horizontalEdges(padding: 12))
		titleImageView.pin(.fixedWidth(56), .fixedHeight(56))
		actionButton.pin(.horizontalEdges(padding: 0))
	}

	@objc
	private func actionButtonTapped() {
		hapticManager.run(type: .lightImpact)
		onActionButtonTap()
	}
}
