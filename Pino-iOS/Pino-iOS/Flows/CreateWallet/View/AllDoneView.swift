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
	private let privacyPolicyStackView = UIStackView()
	private let privacyPolicyCheckBox = PinoCheckBox()
	private let getStartedStackView = UIStackView()
	private let privacyPolicyLabel = UITextView()
	private let getStartedButton = PinoButton(style: .deactive, title: "Get Started")
	private var getStarted: () -> Void

	// MARK: Initializers

	init(getStarted: @escaping (() -> Void)) {
		self.getStarted = getStarted
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
		privacyPolicyStackView.addArrangedSubview(privacyPolicyCheckBox)
		privacyPolicyStackView.addArrangedSubview(privacyPolicyLabel)
		getStartedStackView.addArrangedSubview(privacyPolicyStackView)
		getStartedStackView.addArrangedSubview(getStartedButton)
		addSubview(allDoneStackView)
		addSubview(getStartedStackView)

		getStartedButton.addAction(UIAction(handler: { _ in
			self.getStarted()
		}), for: .touchUpInside)

		privacyPolicyCheckBox.addAction(UIAction(handler: { _ in
			self.activateContinueButton(self.privacyPolicyCheckBox.isChecked)
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		allDoneImage.image = UIImage(named: "pino_logo")

		allDoneTitle.text = "You’re all done!"
		allDoneDescription.text = "A one line description should be here"

		setupPrivacyPolicyLinks()
		privacyPolicyLabel.textColor = .Pino.secondaryLabel
		privacyPolicyLabel.font = .PinoStyle.mediumSubheadline
		privacyPolicyLabel.backgroundColor = .Pino.clear

		allDoneStackView.axis = .vertical
		allDoneStackView.spacing = 26
		allDoneStackView.alignment = .center

		titleStackView.axis = .vertical
		titleStackView.spacing = 16
		titleStackView.alignment = .center

		privacyPolicyStackView.axis = .horizontal
		privacyPolicyStackView.spacing = -2

		getStartedStackView.axis = .vertical
		getStartedStackView.spacing = 34
		getStartedStackView.alignment = .leading
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
		privacyPolicyStackView.pin(
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

	private func setupPrivacyPolicyLinks() {
		#warning("This must be replaced with pino urls")
		let temporaryTermOfServiceURL = URL(string: "http://google.com/")!
		let temporaryPrivacyPolicyURL = URL(string: "http://google.com/")!
		let attributedText = NSMutableAttributedString(string: "I agree to the Term of use and Privacy policy")
		let termOfUseRange = (attributedText.string as NSString).range(of: "Term of use")
		let privacyPolicyRange = (attributedText.string as NSString).range(of: "Privacy policy")
		attributedText.setAttributes([.link: temporaryTermOfServiceURL], range: termOfUseRange)
		attributedText.setAttributes([.link: temporaryPrivacyPolicyURL], range: privacyPolicyRange)
		privacyPolicyLabel.attributedText = attributedText
		privacyPolicyLabel.isEditable = false
		privacyPolicyLabel.isScrollEnabled = false
		privacyPolicyLabel.linkTextAttributes = [
			.foregroundColor: UIColor.Pino.primary,
			.font: UIFont.PinoStyle.semiboldSubheadline as Any,
		]
	}
}
