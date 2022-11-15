//
//  VerifySecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//
// swiftlint: disable force_cast

import UIKit

class VerifySecretPhraseView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let pageTitle = UILabel()
	private let pageDescription = UILabel()
	private let sortedPhraseBoxView = UIView()
	private let sortedPhraseCollectionView = SecretPhraseCollectionView()
	private let errorStackView = UIStackView()
	private let errorLabel = UILabel()
	private let errorIcon = UIImageView()
	private let randomPhraseCollectionView = SecretPhraseCollectionView()
	private let continueButton = PinoButton(style: .deactive, title: "Continue")
	private var createWallet: ([SeedPhrase]) -> Void
	private var userSecretPhrase: [SeedPhrase]
	private var randomPhrase: [SeedPhrase]
	private var sortedPhrase: [SeedPhrase] = []

	// MARK: Initializers

	init(_ secretPhrase: [SeedPhrase], createWallet: @escaping (([SeedPhrase]) -> Void)) {
		self.createWallet = createWallet
		self.userSecretPhrase = secretPhrase
		self.randomPhrase = secretPhrase.shuffled()
		super.init(frame: .zero)

		randomPhraseCollectionView.seedPhrase = randomPhrase
		sortedPhraseCollectionView.seedPhrase = []
		randomPhraseCollectionView.defultStyle = .noSequence
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	private func activateContinueButton(_ isActive: Bool) {
		if isActive {
			continueButton.style = .active
		} else {
			continueButton.style = .deactive
		}
	}
}

extension VerifySecretPhraseView {
	// MARK: UI Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(sortedPhraseBoxView)
		contentStackView.addArrangedSubview(randomPhraseCollectionView)
		titleStackView.addArrangedSubview(pageTitle)
		titleStackView.addArrangedSubview(pageDescription)
		errorStackView.addArrangedSubview(errorIcon)
		errorStackView.addArrangedSubview(errorLabel)
		sortedPhraseBoxView.addSubview(sortedPhraseCollectionView)
		sortedPhraseBoxView.addSubview(errorStackView)
		addSubview(contentStackView)
		addSubview(continueButton)

		continueButton.addAction(UIAction(handler: { _ in
			if self.continueButton.style == .active {
				self.createWallet( self.sortedPhrase )
			}
		}), for: .touchUpInside)

		randomPhraseCollectionView.wordSelected = { seedPhrase in
		}
		sortedPhraseCollectionView.wordSelected = { seedPhrase in
		}
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		pageTitle.text = "Verify seed pharase"
		pageTitle.textColor = .Pino.label
		pageTitle.font = .PinoStyle.semiboldTitle2

		pageDescription.text = "A two line description should be here. A two line description should be here"
		pageDescription.textColor = .Pino.secondaryLabel
		pageDescription.font = .PinoStyle.mediumCallout
		pageDescription.numberOfLines = 0

		errorLabel.text = "Invalid order! Try again"
		errorLabel.textColor = .Pino.ErrorRed
		errorLabel.font = .PinoStyle.mediumCallout
		errorLabel.textAlignment = .center
		errorStackView.isHidden = true

		errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")
		errorIcon.tintColor = .Pino.ErrorRed

		contentStackView.axis = .vertical
		contentStackView.spacing = 32

		titleStackView.axis = .vertical
		titleStackView.spacing = 12

		errorStackView.axis = .horizontal
		errorStackView.spacing = 5

		sortedPhraseBoxView.backgroundColor = .Pino.background
	}

	private func setupContstraint() {
		contentStackView.pin(.top(padding: 115), .horizontalEdges)
		titleStackView.pin(.horizontalEdges(padding: 16))
		continueButton.pin(.bottom(padding: 42), .horizontalEdges(padding: 16), .fixedHeight(56))
		sortedPhraseBoxView.pin(.horizontalEdges, .height(to: randomPhraseCollectionView, padding: 100))
		sortedPhraseCollectionView.pin(.horizontalEdges(padding: 16), .top(padding: 16))
		errorStackView.pin(.bottom(to: sortedPhraseBoxView, padding: 16), .centerX)
		randomPhraseCollectionView.pin(.horizontalEdges(padding: 16))
	}
}
