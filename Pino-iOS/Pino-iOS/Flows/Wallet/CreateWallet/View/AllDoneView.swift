//
//  AllDoneView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//
// swiftlint: disable trailing_comma

import Lottie
import UIKit

class AllDoneView: UIView {
	// MARK: - Private Properties

	private let allDoneStackView = UIStackView()
	private let allDoneAnimationContainerView = UIView()
	private let allDoneAnimationView = LottieAnimationView()
	private let titleStackView = UIStackView()
	private let allDoneTitle = PinoLabel(style: .title, text: nil)
	private let allDoneDescription = PinoLabel(style: .description, text: nil)
	private let agreementStackView = UIStackView()
	private let agreementCheckBox = PinoCheckBox()
	private let getStartedStackView = UIStackView()
	private let agreementLabel = UITextView()
	private let getStartedButton = PinoButton(style: .deactive)
	private var getStarted: () -> Void
	private var allDoneVM: AllDoneViewModel

	// MARK: - Initializers

	init(allDoneVM: AllDoneViewModel, getStarted: @escaping (() -> Void)) {
		self.getStarted = getStarted
		self.allDoneVM = allDoneVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - View Overrides

	override func removeFromSuperview() {
		allDoneAnimationView.animation = nil
	}
}

extension AllDoneView {
	// MARK: - Public Methods

	public func activeGetStartedButton() {
		getStartedButton.style = .active
	}

	// MARK: - Private Methods

	private func setupView() {
		allDoneAnimationContainerView.addSubview(allDoneAnimationView)

		allDoneStackView.addArrangedSubview(allDoneAnimationContainerView)
		allDoneStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(allDoneTitle)
		titleStackView.addArrangedSubview(allDoneDescription)
		agreementStackView.addArrangedSubview(agreementCheckBox)
		agreementStackView.addArrangedSubview(agreementLabel)
		getStartedStackView.addArrangedSubview(agreementStackView)
		getStartedStackView.addArrangedSubview(getStartedButton)
		addSubview(allDoneStackView)
		addSubview(getStartedStackView)

		getStartedButton.addAction(UIAction(handler: { _ in
			self.getStartedButton.style = .loading
			self.getStarted()
		}), for: .touchUpInside)

		agreementCheckBox.addAction(UIAction(handler: { _ in
			self.activateContinueButton(self.agreementCheckBox.isChecked)
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		allDoneAnimationView.animation = LottieAnimation.named(allDoneVM.allDoneAnimationName)
		allDoneAnimationView.loopMode = .playOnce
		allDoneAnimationView.currentProgress = 0.35
		allDoneAnimationView.contentMode = .scaleAspectFill
		allDoneAnimationView.play()

		allDoneTitle.text = allDoneVM.title
		allDoneDescription.text = allDoneVM.description
		getStartedButton.title = allDoneVM.continueButtonTitle

		backgroundColor = .Pino.secondaryBackground

		allDoneStackView.axis = .vertical
		titleStackView.axis = .vertical
		agreementStackView.axis = .horizontal
		getStartedStackView.axis = .vertical

		allDoneStackView.spacing = 26
		titleStackView.spacing = 16
		agreementStackView.spacing = -2
		getStartedStackView.spacing = 34

		allDoneStackView.alignment = .center
		titleStackView.alignment = .center
		getStartedStackView.alignment = .leading

		setupAgreementLinks()
	}

	private func setupContstraint() {
		allDoneStackView.pin(
			.centerY(padding: -200),
			.centerX
		)
		getStartedStackView.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges
		)
		allDoneAnimationView.pin(
			.fixedWidth(400),
			.fixedHeight(400),
			.relative(.bottom, 45, to: allDoneAnimationContainerView, .bottom),
			.centerX
		)
		allDoneAnimationContainerView.pin(.horizontalEdges(to: layoutMarginsGuide, padding: 0), .fixedHeight(400))
		getStartedButton.pin(
			.horizontalEdges(padding: 16)
		)
		agreementStackView.pin(
			.leading(padding: 16),
			.trailing(padding: 0)
		)
	}

	private func activateContinueButton(_ isActive: Bool) {
		if isActive {
			getStartedButton.style = .active
		} else {
			getStartedButton.style = .deactive
		}
	}

	private func setupAgreementLinks() {
		agreementLabel.attributedText = allDoneVM.agreementAttributedTest
		agreementLabel.isEditable = false
		agreementLabel.isSelectable = false
		agreementLabel.isScrollEnabled = false
		agreementLabel.linkTextAttributes = [
			.foregroundColor: UIColor.Pino.primary,
			.font: UIFont.PinoStyle.semiboldSubheadline as Any,
		]
		agreementLabel.textColor = .Pino.secondaryLabel
		agreementLabel.font = .PinoStyle.mediumSubheadline
		agreementLabel.backgroundColor = .Pino.clear
	}
}
