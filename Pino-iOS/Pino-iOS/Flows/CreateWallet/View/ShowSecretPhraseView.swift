//
//  ShowSecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

class ShowSecretPhraseView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let firstDescriptionBox = UIView()
	private let secondDescriptionBox = UIView()
	private let firstDescriptionLabel = PinoLabel(style: .description, text: nil)
	private let secondDescriptionLabel = PinoLabel(style: .description, text: nil)
	private let seedPhraseView = UIView()
	private let revealLabel = PinoLabel(style: .title, text: nil)
	private let seedPhraseBlurView = BlurEffectView()
	private let seedPhraseStackView = UIStackView()
	private let seedPhraseCollectionView = SecretPhraseCollectionView()
	private let shareButton = UIButton()
	private let continueButton = PinoButton(style: .deactive, title: "I Saved")
	private var shareSecretPhrase: () -> Void
	private var savedSecretPhrase: () -> Void

	// MARK: Initializers

	init(_ secretPhrase: [String], shareSecretPhare: @escaping (() -> Void), savedSecretPhrase: @escaping (() -> Void)) {
		self.shareSecretPhrase = shareSecretPhare
		self.savedSecretPhrase = savedSecretPhrase
		super.init(frame: .zero)
		seedPhraseCollectionView.secretWords = secretPhrase
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension ShowSecretPhraseView {
	// MARK: UI Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(seedPhraseView)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(firstDescriptionBox)
		titleStackView.addArrangedSubview(secondDescriptionBox)
		firstDescriptionBox.addSubview(firstDescriptionLabel)
		secondDescriptionBox.addSubview(secondDescriptionLabel)
		seedPhraseView.addSubview(seedPhraseStackView)
		seedPhraseView.addSubview(seedPhraseBlurView)
		seedPhraseView.addSubview(revealLabel)
		seedPhraseStackView.addArrangedSubview(seedPhraseCollectionView)
		seedPhraseStackView.addArrangedSubview(shareButton)
		addSubview(contentStackView)
		addSubview(continueButton)

		let revealTapGesture = UITapGestureRecognizer(target: self, action: #selector(showSeedPhrase))
		seedPhraseView.addGestureRecognizer(revealTapGesture)

		shareButton.addAction(UIAction(handler: { _ in
			self.shareSecretPhrase()
		}), for: .touchUpInside)

		continueButton.addAction(UIAction(handler: { _ in
			self.savedSecretPhrase()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		titleLabel.text = "Backup seed phrase"
		revealLabel.text = "Tap to reveal"
		firstDescriptionLabel.text = "Write down your Secret Phrase and store it in a safe place."
		firstDescriptionLabel.textColor = .Pino.label
		secondDescriptionLabel.text = "It allows you to recover your wallet if you lose your device or password"
		secondDescriptionLabel.textColor = .Pino.label

		firstDescriptionBox.backgroundColor = .Pino.background
		firstDescriptionBox.layer.cornerRadius = 8
		secondDescriptionBox.backgroundColor = .Pino.background
		secondDescriptionBox.layer.cornerRadius = 8

		shareButton.setTitle("Copy", for: .normal)
		shareButton.setTitleColor(.Pino.primary, for: .normal)
		shareButton.titleLabel?.font = .PinoStyle.semiboldBody
		shareButton.setImage(UIImage(systemName: "square.on.square"), for: .normal)
		shareButton.imageView?.tintColor = .Pino.primary

		contentStackView.axis = .vertical
		contentStackView.spacing = 8

		titleStackView.axis = .vertical
		titleStackView.spacing = 12
		titleStackView.alignment = .leading

		seedPhraseStackView.axis = .vertical
		seedPhraseStackView.spacing = 52
		seedPhraseStackView.alignment = .center
	}

	private func setupContstraint() {
		firstDescriptionLabel.pin(
			.verticalEdges(padding: 14),
			.horizontalEdges(padding: 10)
		)
		secondDescriptionLabel.pin(
			.verticalEdges(padding: 14),
			.horizontalEdges(padding: 10)
		)
		firstDescriptionBox.pin(
			.horizontalEdges(padding: 16)
		)
		secondDescriptionBox.pin(
			.horizontalEdges(padding: 16)
		)
		titleLabel.pin(
			.horizontalEdges(padding: 16)
		)
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 25),
			.horizontalEdges
		)
		continueButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		seedPhraseCollectionView.pin(
			.horizontalEdges
		)
		seedPhraseStackView.pin(
			.allEdges(padding: 16)
		)
		seedPhraseBlurView.pin(
			.allEdges()
		)
		revealLabel.pin(
			.centerX,
			.centerY
		)
	}

	@objc
	private func showSeedPhrase() {
		UIView.animate(withDuration: 0.5) {
			self.seedPhraseBlurView.alpha = 0
			self.revealLabel.alpha = 0
			self.continueButton.style = .active
		}
	}
}
