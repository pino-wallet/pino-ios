//
//  NoInternetConnectionViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/21/23.
//

import UIKit

class NoInternetConnectionView: UIView {
	// MARK: Private Properties

	private let noInternetStackView = UIStackView()
	private let noInternetImage = UIImageView()
	private let noInternetImageBackground = UIView()
	private let titleStackView = UIStackView()
	private let noInternetTitle = PinoLabel(style: .title, text: nil)
	private let noInternetDescription = PinoLabel(style: .description, text: nil)
	private let retryButton = PinoButton(style: .active)
	private var retryTapped: () -> Void
	private var noInternetConnectionVM: NoInternetConnectionViewModel

	// MARK: Initializers

	init(retryTapped: @escaping (() -> Void)) {
		self.retryTapped = retryTapped
		self.noInternetConnectionVM = NoInternetConnectionViewModel()
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension NoInternetConnectionView {
	// MARK: UI Methods

	private func setupView() {
		noInternetStackView.addArrangedSubview(titleStackView)
		noInternetStackView.addArrangedSubview(retryButton)
		titleStackView.addArrangedSubview(noInternetImageBackground)
		titleStackView.addArrangedSubview(noInternetTitle)
		titleStackView.addArrangedSubview(noInternetDescription)
		noInternetImageBackground.addSubview(noInternetImage)
		addSubview(noInternetStackView)

		retryButton.addAction(UIAction(handler: { _ in
			self.retryTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		noInternetImage.image = UIImage(systemName: noInternetConnectionVM.image)

		noInternetTitle.text = noInternetConnectionVM.title
		noInternetDescription.text = noInternetConnectionVM.description
		retryButton.title = noInternetConnectionVM.RetryButtonTitle

		backgroundColor = .Pino.secondaryBackground
		noInternetImageBackground.backgroundColor = .Pino.background

		noInternetImage.tintColor = .Pino.label

		noInternetTitle.font = .PinoStyle.semiboldBody
		noInternetDescription.font = .PinoStyle.mediumSubheadline

		noInternetStackView.axis = .vertical
		titleStackView.axis = .vertical

		noInternetStackView.spacing = 30
		titleStackView.spacing = 16

		noInternetStackView.alignment = .center
		titleStackView.alignment = .center
		noInternetTitle.textAlignment = .center
		noInternetDescription.textAlignment = .center

		noInternetImageBackground.layer.cornerRadius = 32
	}

	private func setupContstraint() {
		noInternetStackView.pin(
			.centerY(padding: -32),
			.horizontalEdges(padding: 16)
		)
		noInternetImageBackground.pin(
			.fixedWidth(64),
			.fixedHeight(64)
		)
		noInternetImage.pin(
			.allEdges(padding: 16)
		)
		retryButton.pin(
			.fixedWidth(167),
			.fixedHeight(48)
		)
	}
}
