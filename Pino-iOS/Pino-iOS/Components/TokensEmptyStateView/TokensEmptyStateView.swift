//
//  ManageAssetEmptyStateView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/14/24.
//

import Foundation
import UIKit

class TokensEmptyStateView: UIView {
	// MARK: - Closures

	private var onActionButton: () -> Void

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleImageView = UIImageView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let textStackView = UIStackView()
	private let descriptionStackView = UIStackView()
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let actionLabel = UILabel()
	private var tokensEmptyStateTexts: TokensEmptyStateTexts {
		didSet {
			updateUI()
		}
	}

	// MARK: - Initializers

	init(tokensEmptyStateTexts: TokensEmptyStateTexts, onImportButton: @escaping () -> Void = {}) {
		self.tokensEmptyStateTexts = tokensEmptyStateTexts
		self.onActionButton = onImportButton

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		updateUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		let onImportTapGesture = UITapGestureRecognizer(target: self, action: #selector(onActionTap))
		actionLabel.addGestureRecognizer(onImportTapGesture)
		actionLabel.isUserInteractionEnabled = true

		mainStackView.addArrangedSubview(titleImageView)
		mainStackView.addArrangedSubview(textStackView)

		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionStackView)

		descriptionStackView.addArrangedSubview(descriptionLabel)
		descriptionStackView.addArrangedSubview(actionLabel)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		mainStackView.axis = .vertical
		mainStackView.spacing = 24
		mainStackView.alignment = .center

		textStackView.axis = .vertical
		textStackView.spacing = 8
		textStackView.alignment = .center

		descriptionStackView.axis = .horizontal
		descriptionStackView.spacing = 2
		descriptionStackView.alignment = .center

		titleLabel.font = .PinoStyle.semiboldTitle2

		descriptionLabel.font = .PinoStyle.mediumBody

		actionLabel.textColor = .Pino.primary
		actionLabel.font = .PinoStyle.boldBody
	}

	private func updateUI() {
		titleImageView.image = UIImage(named: tokensEmptyStateTexts.titleImageName)

		titleLabel.text = tokensEmptyStateTexts.titleText

		descriptionLabel.text = tokensEmptyStateTexts.descriptionText

		actionLabel.text = tokensEmptyStateTexts.buttonTitle

		if tokensEmptyStateTexts.buttonTitle != nil {
			actionLabel.isHidden = false
		} else {
			actionLabel.isHidden = true
		}
	}

	private func setupConstraints() {
		titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
		descriptionStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		mainStackView.pin(.horizontalEdges(padding: 16), .centerY)
		titleImageView.pin(.fixedWidth(56), .fixedHeight(56))
	}

	@objc
	private func onActionTap() {
		onActionButton()
	}
}
