//
//  ImportAccountLoadingView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/16/23.
//

import UIKit

class ImportAccountLoadingView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let searchImageBackgroundView = UIStackView()
	private let searchImageView = UIImageView()
	private let loadingTitleLabel = UILabel()
	private let loadingDescriptionLabel = UILabel()

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(searchImageBackgroundView)
		contentStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(loadingTitleLabel)
		titleStackView.addArrangedSubview(loadingDescriptionLabel)
		searchImageBackgroundView.addSubview(searchImageView)
	}

	private func setupStyle() {
		loadingTitleLabel.text = "Finding your accounts"
		loadingDescriptionLabel.text = "This may take a few seconds"

		searchImageView.image = UIImage(named: "search")

		loadingTitleLabel.font = .PinoStyle.semiboldTitle2
		loadingDescriptionLabel.font = .PinoStyle.mediumBody

		loadingTitleLabel.textColor = .Pino.label
		loadingDescriptionLabel.textColor = .Pino.secondaryLabel

		backgroundColor = .Pino.secondaryBackground
		searchImageBackgroundView.backgroundColor = .Pino.lightGreen

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackView.spacing = 28
		titleStackView.spacing = 14

		contentStackView.alignment = .center
		titleStackView.alignment = .center

		searchImageBackgroundView.layer.cornerRadius = 32
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.centerY
		)
		searchImageView.pin(
			.allEdges(padding: 12)
		)
		searchImageBackgroundView.pin(
			.fixedWidth(64),
			.fixedHeight(64)
		)
	}
}
