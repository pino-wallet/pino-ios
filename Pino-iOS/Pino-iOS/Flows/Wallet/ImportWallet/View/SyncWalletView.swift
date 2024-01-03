//
//  SyncWalletView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/1/24.
//

import Foundation
import UIKit
import Lottie

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
	private let loadingContainerView = UIView()
	private let loadingProgressView = UIView()
	private let syncWalletVM: SyncWalletViewModel
    private let titleAnimationViewContainer = UIView()
    private var titleAnimationView = LottieAnimationView()

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

	// MARK: - Private Methods

	private func setupView() {
		exploreButton.addTarget(self, action: #selector(onExpolePinoTap), for: .touchUpInside)

		exploreStackView.addArrangedSubview(exploreTitleLabel)
		exploreStackView.addArrangedSubview(exploreButton)

		loadingContainerView.addSubview(loadingProgressView)

		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(loadingContainerView)
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

		loadingContainerView.layer.cornerRadius = 2
		loadingContainerView.backgroundColor = .Pino.gray4

		loadingProgressView.layer.cornerRadius = 2
		loadingProgressView.backgroundColor = .Pino.primary

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

		loadingContainerView.pin(.fixedHeight(4), .fixedWidth(296))
		loadingProgressView.pin(.leading(padding: 0), .verticalEdges(padding: 0))

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
		layoutIfNeeded()
		UIView.animate(withDuration: syncWalletVM.loadingTime, animations: { [weak self] in
			self?.loadingProgressView.pin(.horizontalEdges(padding: 0))
			self?.layoutIfNeeded()
		}, completion: { _ in
			#warning("we should use this to go to next page")
		})
	}
}
