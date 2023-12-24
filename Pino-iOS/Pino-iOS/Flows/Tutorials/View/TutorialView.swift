//
//  TutorialView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Combine
import Foundation
import Lottie
import UIKit

class TutorialView: UIView {
	// MARK: - Public Properties

	// MARK: - Private Properties

	private let skipLeftView = UIView()
	private let skipRightView = UIView()
	private var tutorialVM: TutorialContainerViewModel!
	private let stepperCollectionView: TutorialStepperContainerView!
	private var animationView = LottieAnimationView()
	private var titleLabel = UILabel()
	private var bodyLabel = UILabel()
	private var contentStackView = UIStackView()
	private var titleBodyStackView = UIStackView()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(tutorialVM: TutorialContainerViewModel) {
		self.tutorialVM = tutorialVM
		self.stepperCollectionView = TutorialStepperContainerView(tutorialVM: tutorialVM)
		super.init(frame: .zero)
		setupView()
		addGeatures()
		setupStyles()
		setupConstraints()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		animationView = .init(name: tutorialVM.tutorials.first!.lottieFile)
		animationView.play()

		titleLabel.text = tutorialVM.tutorials.first?.title
		bodyLabel.text = tutorialVM.tutorials.first?.desc

		titleLabel.font = UIFont.PinoStyle.boldBigTitle
		titleLabel.numberOfLines = 0
		titleLabel.textColor = .Pino.primary

		bodyLabel.font = UIFont.PinoStyle.mediumBody
		bodyLabel.numberOfLines = 0
		bodyLabel.textColor = .Pino.primary

		contentStackView.spacing = 40
		titleBodyStackView.spacing = 24

		contentStackView.axis = .vertical
		titleBodyStackView.axis = .vertical

		titleBodyStackView.addArrangedSubview(titleLabel)
		titleBodyStackView.addArrangedSubview(bodyLabel)

		contentStackView.addArrangedSubview(animationView)
		contentStackView.addArrangedSubview(titleBodyStackView)

		addSubview(contentStackView)
		addSubview(stepperCollectionView)
		addSubview(skipLeftView)
		addSubview(skipRightView)
	}

	private func addGeatures() {
		let skipLeftGesture = UITapGestureRecognizer(target: self, action: #selector(skipLeft))
		skipLeftView.addGestureRecognizer(skipLeftGesture)

		let skipRightGesture = UITapGestureRecognizer(target: self, action: #selector(skipRight))
		skipRightView.addGestureRecognizer(skipRightGesture)

		let holdRightGesture = UILongPressGestureRecognizer(target: self, action: #selector(holdTutorial))
		let holdLeftGesture = UILongPressGestureRecognizer(target: self, action: #selector(holdTutorial))
		skipLeftView.addGestureRecognizer(holdRightGesture)
		skipRightView.addGestureRecognizer(holdLeftGesture)

		holdRightGesture.minimumPressDuration = 0.2
		holdRightGesture.delaysTouchesBegan = true

		holdLeftGesture.minimumPressDuration = 0.2
		holdLeftGesture.delaysTouchesBegan = true

		animationView.contentMode = .scaleAspectFit
		animationView.loopMode = .loop
		animationView.animationSpeed = 1
		animationView.backgroundColor = .clear
	}

	private func setupStyles() {
		backgroundColor = .Pino.lightBlue
		skipLeftView.backgroundColor = .clear
		skipRightView.backgroundColor = .clear
		stepperCollectionView.backgroundColor = .clear
	}

	private func setupConstraints() {
		stepperCollectionView.pin(
			.top(to: layoutMarginsGuide, padding: 20),
			.horizontalEdges(padding: 12),
			.fixedHeight(3)
		)
		skipLeftView.pin(
			.leading,
			.verticalEdges
		)
		skipRightView.pin(
			.trailing,
			.verticalEdges
		)

		contentStackView.pin(
			.top(to: stepperCollectionView, padding: 63),
			.centerX,
			.horizontalEdges(padding: 24)
		)

		animationView.pin(
			.centerX,
			.fixedWidth(256),
			.fixedHeight(256)
		)

		NSLayoutConstraint.activate([
			skipRightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
			skipLeftView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
		])
	}

	func setupBindings() {
		tutorialVM.$currentIndex.compactMap { $0 }.sink { [self] tutIndex in
			guard tutIndex < tutorialVM.tutorials.count else { return }
			animationView.pause()
			animationView.animation = LottieAnimation.named(tutorialVM.tutorials[tutIndex].lottieFile)
			animationView.play()

			titleLabel.text = tutorialVM.tutorials[tutIndex].title
			bodyLabel.text = tutorialVM.tutorials[tutIndex].desc
		}.store(in: &cancellables)
	}

	@objc
	private func skipLeft() {
		tutorialVM.prevTutorial()
	}

	@objc
	private func skipRight() {
		tutorialVM.nextTutorial()
	}

	@objc
	private func holdTutorial(gestureReconizer: UILongPressGestureRecognizer) {
		if gestureReconizer.state == .began {
			tutorialVM.isPaused = true
		}
		if gestureReconizer.state == .ended {
			tutorialVM.isPaused = false
		}
	}
}
