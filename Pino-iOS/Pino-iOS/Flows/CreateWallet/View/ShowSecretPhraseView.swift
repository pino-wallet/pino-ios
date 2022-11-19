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
	private let titleLabel = UILabel()
	private let firstDescriptionBox = UIView()
	private let secondDescriptionBox = UIView()
	private let firstDescriptionLabel = UILabel()
	private let secondDescriptionLabel = UILabel()
	private let seedPhraseView = UIView()
	private let revealButton = UIButton()
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
		seedPhraseCollectionView.words = secretPhrase
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
		seedPhraseView.addSubview(revealButton)
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
			if self.continueButton.style == .active {
				self.savedSecretPhrase()
			}
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		titleLabel.text = "Backup seed pharase"
		titleLabel.textColor = .Pino.label
		titleLabel.font = .PinoStyle.semiboldTitle3

		firstDescriptionLabel.text = "Write down your Secret Phrase and store it in a safe place."
		firstDescriptionLabel.textColor = .Pino.label
		firstDescriptionLabel.font = .PinoStyle.mediumCallout
		firstDescriptionLabel.numberOfLines = 0

		secondDescriptionLabel.text = "It allows you to recover your wallet if you lose your device or password"
		secondDescriptionLabel.textColor = .Pino.label
		secondDescriptionLabel.font = .PinoStyle.mediumCallout
		secondDescriptionLabel.numberOfLines = 0

		firstDescriptionBox.backgroundColor = .Pino.background
		firstDescriptionBox.layer.cornerRadius = 8

		secondDescriptionBox.backgroundColor = .Pino.background
		secondDescriptionBox.layer.cornerRadius = 8

		shareButton.setTitle("Copy", for: .normal)
		shareButton.setTitleColor(.Pino.primary, for: .normal)
		shareButton.titleLabel?.font = .PinoStyle.semiboldBody
		shareButton.setImage(UIImage(systemName: "square.on.square"), for: .normal)
		shareButton.imageView?.tintColor = .Pino.primary

		revealButton.setTitle("Tap to reveal", for: .normal)
		revealButton.setTitleColor(.Pino.label, for: .normal)
		revealButton.titleLabel?.font = .PinoStyle.semiboldTitle3

		contentStackView.axis = .vertical
		contentStackView.spacing = 32

		titleStackView.axis = .vertical
		titleStackView.spacing = 10

		seedPhraseStackView.axis = .vertical
		seedPhraseStackView.spacing = 32
		seedPhraseStackView.alignment = .center
	}

	private func setupContstraint() {
		firstDescriptionLabel.pin(
			.allEdges(padding: 12)
		)
		secondDescriptionLabel.pin(
			.allEdges(padding: 12)
		)
		contentStackView.pin(
			.top(padding: 115),
			.horizontalEdges(padding: 16)
		)
		continueButton.pin(
			.bottom(padding: 42),
			.horizontalEdges(padding: 16),
			.fixedHeight(56)
		)
		seedPhraseCollectionView.pin(
			.horizontalEdges
		)
		seedPhraseStackView.pin(
			.verticalEdges(padding: 10),
			.horizontalEdges
		)
		seedPhraseBlurView.pin(
			.allEdges()
		)
		revealButton.pin(
			.centerX,
			.centerY
		)
	}

	@objc
	private func showSeedPhrase() {
		seedPhraseBlurView.isHidden = true
		revealButton.isHidden = true
		continueButton.style = .active
	}
}
