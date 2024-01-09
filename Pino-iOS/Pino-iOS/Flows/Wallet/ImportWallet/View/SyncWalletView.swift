//
//  SyncWalletView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/1/24.
//

import Foundation
import Lottie
import UIKit

class SyncWalletView: UIView {
	// MARK: - Closures

	private let presentTutorialPage: () -> Void

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let exploreStackView = UIStackView()
	private let exploreTitleLabel = PinoLabel(style: .title, text: "")
	private let exploreButton = PinoButton(style: .secondary)
	private let syncWalletVM: SyncWalletViewModel
	private let titleAnimationViewContainer = UIView()
	private var titleAnimationView = LottieAnimationView()
	private var progressView: PinoProgressView!

	// MARK: - Initializers

	init(syncWalletVM: SyncWalletViewModel, presentTutorialPage: @escaping () -> Void) {
		self.syncWalletVM = syncWalletVM
		self.presentTutorialPage = presentTutorialPage

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func removeFromSuperview() {
		titleAnimationView.animation = nil
	}

	// MARK: - Private Methods

	private func setupView() {
		progressView = PinoProgressView(progressBarVM: .init(progressDuration: syncWalletVM.loadingTime))
		progressView.completion = {
			#warning("here we should go to next page")
		}

		exploreButton.addTarget(self, action: #selector(onExpolePinoTap), for: .touchUpInside)

		exploreStackView.addArrangedSubview(exploreTitleLabel)
		exploreStackView.addArrangedSubview(exploreButton)

		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(progressView)
		titleStackView.addArrangedSubview(descriptionLabel)

		titleAnimationViewContainer.addSubview(titleAnimationView)

		mainStackView.addArrangedSubview(titleAnimationViewContainer)
		mainStackView.addArrangedSubview(titleStackView)

		addSubview(mainStackView)
		addSubview(exploreStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		titleLabel.font = .PinoStyle.semiboldTitle2
		titleLabel.text = syncWalletVM.titleText
		titleLabel.textAlignment = .center

		titleAnimationView.animation = LottieAnimation.named(syncWalletVM.titleAnimationName)
		titleAnimationView.loopMode = .loop
		titleAnimationView.contentMode = .scaleAspectFit
		titleAnimationView.play()

		descriptionLabel.font = .PinoStyle.mediumSubheadline
		descriptionLabel.text = syncWalletVM.descriptionText
		descriptionLabel.textAlignment = .center

		mainStackView.axis = .vertical
		mainStackView.alignment = .center
		mainStackView.spacing = 53

		titleStackView.axis = .vertical
		titleStackView.alignment = .center
		titleStackView.spacing = 16
		titleStackView.setCustomSpacing(12, after: titleLabel)

		exploreStackView.axis = .vertical
		exploreStackView.spacing = 24

		exploreTitleLabel.font = .PinoStyle.mediumSubheadline
		exploreTitleLabel.text = syncWalletVM.exploreTitleText
		exploreTitleLabel.textAlignment = .center

		exploreButton.title = syncWalletVM.explorePinoButtonText
	}

	private func setupConstraints() {
		descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 248).isActive = true

		titleStackView.pin(.horizontalEdges(padding: 60))
		progressView.pin(.horizontalEdges)
		mainStackView.pin(.top(to: layoutMarginsGuide, padding: 154), .horizontalEdges(padding: 16))
		titleAnimationViewContainer.pin(.fixedWidth(181), .fixedHeight(181))
		titleAnimationView.pin(.horizontalEdges(padding: -30), .verticalEdges(padding: -30), .centerX, .centerY)
		exploreStackView.pin(.horizontalEdges(padding: 16), .bottom(to: layoutMarginsGuide, padding: 12))
	}

	@objc
	private func onExpolePinoTap() {
		presentTutorialPage()
	}

	// MARK: - Public Properties

	public func animateLoading() {
		progressView.start()
	}
}
