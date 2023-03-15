//
//  RecoveryPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

import UIKit

class RecoveryPhraseView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let seedPhraseView = UIView()
	private let revealLabel = PinoLabel(style: .title, text: nil)
	private let seedPhraseBlurView = BlurEffectView()
	private let seedPhraseStackView = UIStackView()
	private let seedPhraseCollectionView = SecretPhraseCollectionView()
	private let shareButton = UIButton()
	private let continueButton = PinoButton(style: .deactive)
	private var shareSecretPhrase: () -> Void
	private var savedSecretPhrase: () -> Void
	private var secretPhraseVM: ShowSecretPhraseViewModel

	// MARK: - Initializers

	init(
		secretPhraseVM: ShowSecretPhraseViewModel,
		shareSecretPhare: @escaping (() -> Void),
		savedSecretPhrase: @escaping (() -> Void)
	) {
		self.shareSecretPhrase = shareSecretPhare
		self.savedSecretPhrase = savedSecretPhrase
		self.secretPhraseVM = secretPhraseVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		seedPhraseCollectionView.secretWords = secretPhraseVM.secretPhraseList

		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(seedPhraseView)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
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
		titleLabel.text = secretPhraseVM.title
		descriptionLabel.text = secretPhraseVM.firstDescription
		revealLabel.text = secretPhraseVM.revealButtonTitle
		shareButton.setTitle(secretPhraseVM.shareButtonTitle, for: .normal)
		continueButton.title = secretPhraseVM.continueButtonTitle

		let shareButtonImage = UIImage(systemName: secretPhraseVM.shareButtonIcon)
		shareButton.setImage(shareButtonImage, for: .normal)

		backgroundColor = .Pino.secondaryBackground

		shareButton.setTitleColor(.Pino.primary, for: .normal)
		shareButton.imageView?.tintColor = .Pino.primary

		titleLabel.font = .PinoStyle.mediumTitle2
		shareButton.titleLabel?.font = .PinoStyle.semiboldBody

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical
		seedPhraseStackView.axis = .vertical

		contentStackView.spacing = 30
		titleStackView.spacing = 12
		seedPhraseStackView.spacing = 52

		titleStackView.alignment = .leading
		seedPhraseStackView.alignment = .center
	}

	private func setupContstraint() {
		titleStackView.pin(
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
