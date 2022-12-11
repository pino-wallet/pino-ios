//
//  AllDoneView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//
// swiftlint: disable trailing_comma

import UIKit

class AllDoneView: UIView {
	// MARK: Private Properties

	private let allDoneStackView = UIStackView()
	private let allDoneImage = UIImageView()
	private let titleStackView = UIStackView()
	private let allDoneTitle = PinoLabel(style: .title, text: nil)
	private let allDoneDescription = PinoLabel(style: .description, text: nil)
	private let agreementStackView = UIStackView()
	private let agreementCheckBox = PinoCheckBox()
	private let getStartedStackView = UIStackView()
	private let agreementLabel = UITextView()
	private let getStartedButton = PinoButton(style: .deactive, title: "Get Started")
	private var getStarted: () -> Void
	private var allDoneVM: AllDoneViewModel

	// MARK: Initializers

	init(_ allDoneVM: AllDoneViewModel, getStarted: @escaping (() -> Void)) {
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
}

extension AllDoneView {
	// MARK: UI Methods

	private func setupView() {
		allDoneStackView.addArrangedSubview(allDoneImage)
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
			self.getStarted()
		}), for: .touchUpInside)

		agreementCheckBox.addAction(UIAction(handler: { _ in
			self.activateContinueButton(self.agreementCheckBox.isChecked)
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		allDoneImage.image = allDoneVM.image

		allDoneTitle.text = allDoneVM.title
		allDoneDescription.text = allDoneVM.description

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
			.centerY(padding: -62),
			.centerX
		)
		getStartedStackView.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges
		)
		allDoneImage.pin(
			.fixedWidth(80),
			.fixedHeight(80)
		)
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
