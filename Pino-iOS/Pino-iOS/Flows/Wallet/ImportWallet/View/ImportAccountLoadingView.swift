//
//  ImportAccountLoadingView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/16/23.
//

import Lottie
import UIKit

class ImportAccountLoadingView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let findingAccountLottieBackgroundView = UIView()
	private let loadingTitleLabel = UILabel()
	private let loadingDescriptionLabel = UILabel()
    
    // MARK: - Public Properties
    public let findingAccountLottieAnimationView = LottieAnimationView()

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
		contentStackView.addArrangedSubview(findingAccountLottieBackgroundView)
		contentStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(loadingTitleLabel)
		titleStackView.addArrangedSubview(loadingDescriptionLabel)
		findingAccountLottieBackgroundView.addSubview(findingAccountLottieAnimationView)
	}

	private func setupStyle() {
		loadingTitleLabel.text = "Finding your accounts"
		loadingDescriptionLabel.text = "This may take a few seconds"

		loadingTitleLabel.font = .PinoStyle.semiboldTitle2
		loadingDescriptionLabel.font = .PinoStyle.mediumBody

		loadingTitleLabel.textColor = .Pino.label
		loadingDescriptionLabel.textColor = .Pino.secondaryLabel

		backgroundColor = .Pino.secondaryBackground

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		contentStackView.spacing = 24
		titleStackView.spacing = 14

		contentStackView.alignment = .center
		titleStackView.alignment = .center

		findingAccountLottieAnimationView.animation = LottieAnimation.named("FindingAccount")
		findingAccountLottieAnimationView.loopMode = .loop
		findingAccountLottieAnimationView.contentMode = .scaleAspectFit
		findingAccountLottieAnimationView.play()

		findingAccountLottieBackgroundView.layer.cornerRadius = 28
	}

	private func setupConstraint() {
		contentStackView.pin(
			.horizontalEdges(padding: 16),
			.centerY
		)
		findingAccountLottieAnimationView.pin(.centerX, .centerY, .fixedWidth(115), .fixedHeight(115))
		findingAccountLottieBackgroundView.pin(
			.fixedWidth(56),
			.fixedHeight(56)
		)
	}
}
