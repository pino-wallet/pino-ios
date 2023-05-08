//
//  AllowNotificationsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/7/23.
//

import UIKit

class AllowNotificationsView: UIView {
	// MARK: - Public Properties

	public let allowNotificationsVM: AllowNotificationsViewModel

	// MARK: - Initializers

	init(allowNotificationsVM: AllowNotificationsViewModel) {
		self.allowNotificationsVM = allowNotificationsVM
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Properties

	private let headerStackView = UIStackView()
	private let headerIconContainerView = UIView()
	private let headerIconView = UIImageView()
	private let headerTitleLabelContainerView = UIView()
	private let headerTitleLabel = PinoLabel(style: .title, text: "")
	private let headerDescriptionLabelContainerView = UIView()
	private let headerDescriptionLabel = PinoLabel(style: .info, text: "")

	private let buttonsStackView = UIStackView()
	private let enableNotificationsButton = PinoButton(style: .active, title: "")
	private let skipButton = PinoButton(style: .white, title: "")

	// MARK: - Private Methods

	private func setupView() {
		headerIconContainerView.addSubview(headerIconView)

		headerTitleLabelContainerView.addSubview(headerTitleLabel)

		headerDescriptionLabelContainerView.addSubview(headerDescriptionLabel)

		headerStackView.addArrangedSubview(headerIconContainerView)
		headerStackView.addArrangedSubview(headerTitleLabelContainerView)
		headerStackView.addArrangedSubview(headerDescriptionLabelContainerView)

		buttonsStackView.addArrangedSubview(enableNotificationsButton)
		buttonsStackView.addArrangedSubview(skipButton)

		addSubview(headerStackView)

		addSubview(buttonsStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.white

		headerStackView.axis = .vertical
		headerStackView.spacing = 8
		headerStackView.alignment = .center

		buttonsStackView.axis = .vertical
		buttonsStackView.spacing = 24

		enableNotificationsButton.title = allowNotificationsVM.enableNotificationsButtonTitleText

		skipButton.title = allowNotificationsVM.skipButtonTitleText

		headerIconView.image = UIImage(named: allowNotificationsVM.headerIcon)

		headerTitleLabel.text = allowNotificationsVM.titleText
		headerTitleLabel.numberOfLines = 0
		headerTitleLabel.textAlignment = .center
		headerDescriptionLabel.lineBreakMode = .byWordWrapping
		headerTitleLabel.font = .PinoStyle.semiboldTitle2

		headerDescriptionLabel.text = allowNotificationsVM.descriptionText
		headerDescriptionLabel.numberOfLines = 0
		headerDescriptionLabel.textAlignment = .center
		headerDescriptionLabel.lineBreakMode = .byWordWrapping
		headerDescriptionLabel.textColor = .Pino.secondaryLabel
	}

	private func setupConstraints() {
		headerIconView.pin(.fixedWidth(56), .fixedHeight(56))
		headerStackView.pin(.top(to: layoutMarginsGuide, padding: 8), .horizontalEdges(padding: 16))
		headerTitleLabel.pin(.horizontalEdges(padding: 0), .top(padding: 10), .bottom(padding: 0))
		headerIconView.pin(.allEdges(padding: 0))
		headerDescriptionLabel.pin(.verticalEdges(padding: 0), .horizontalEdges(padding: 16))
		buttonsStackView.pin(.horizontalEdges(padding: 16), .bottom(to: layoutMarginsGuide, padding: 32))
	}
}

extension PinoButton.Style {
	fileprivate static let white = PinoButton.Style(
		titleColor: .Pino.primary,
		backgroundColor: .Pino.white,
		borderColor: .clear
	)
}
