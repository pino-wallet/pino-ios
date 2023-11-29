//
//  TutorialView.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Foundation
import UIKit

class TutorialView: UIView {
	// MARK: - Public Properties

	// MARK: - Private Properties

	private let skipLeftView = UIView()
	private let skipRightView = UIView()
	private var tutorialVM: TutorialContainerViewModel!
	private let stepperCollectionView: TutorialStepperContainerView!

	// MARK: - Initializers

	init(tutorialVM: TutorialContainerViewModel) {
		self.tutorialVM = tutorialVM
		self.stepperCollectionView = TutorialStepperContainerView(tutorialVM: tutorialVM)
		super.init(frame: .zero)
		setupView()
		addGeatures()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(stepperCollectionView)
		addSubview(skipLeftView)
		addSubview(skipRightView)
		stepperCollectionView.backgroundColor = .clear
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
	}

	private func setupStyles() {
		backgroundColor = .Pino.lightBlue
		skipLeftView.backgroundColor = .clear
		skipRightView.backgroundColor = .clear
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

		NSLayoutConstraint.activate([
			skipRightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
			skipLeftView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
		])
	}

	@objc
	private func skipLeft() {
		print("skip left")
		tutorialVM.prevTutorial()
	}

	@objc
	private func skipRight() {
		print("skip right")
		tutorialVM.nextTutorial()
	}

	@objc
	private func holdTutorial() {
		print("HOLDDD")
	}
}
