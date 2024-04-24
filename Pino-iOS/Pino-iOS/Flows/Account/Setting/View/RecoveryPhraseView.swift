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
	private let seedPhraseStackView = UIStackView()
	private let seedPhraseView = UIView()
	private let revealLabel = PinoLabel(style: .title, text: nil)
	private let seedPhraseBlurView = BlurEffectView()
	private let seedPhraseCollectionView = SecretPhraseCollectionView()
	private let copySeedPhraseButton = UIButton()
	private let warningCardView = UIView()
	private let warningStackView = UIStackView()
	private let warningDescriptionLabel = PinoLabel(style: .description, text: nil)
    private let hapticManager = HapticManager()
	private var copySecretPhraseTapped: () -> Void
	private var secretPhraseVM: RecoveryPhraseViewModel
	private let revealTapped: () -> Void

	// MARK: - Initializers

	init(
		secretPhraseVM: RecoveryPhraseViewModel,
		copySecretPhraseTapped: @escaping (() -> Void),
		revealTapped: @escaping () -> Void
	) {
		self.copySecretPhraseTapped = copySecretPhraseTapped
		self.secretPhraseVM = secretPhraseVM
		self.revealTapped = revealTapped
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
		seedPhraseStackView.addArrangedSubview(copySeedPhraseButton)
		warningStackView.addArrangedSubview(warningDescriptionLabel)
		warningCardView.addSubview(warningStackView)
		addSubview(contentStackView)
		addSubview(warningCardView)

		copySeedPhraseButton.addAction(UIAction(handler: { _ in
			self.copySecretPhraseTapped()
		}), for: .touchUpInside)

		let revealTapGesture = UITapGestureRecognizer(target: self, action: #selector(revealSeedPhrase))
		seedPhraseBlurView.addGestureRecognizer(revealTapGesture)
	}

	private func setupStyle() {
		titleLabel.text = secretPhraseVM.title
		descriptionLabel.text = secretPhraseVM.description
		copySeedPhraseButton.setTitle(secretPhraseVM.copyButtonTitle, for: .normal)
		warningDescriptionLabel.text = secretPhraseVM.warningDescription
		revealLabel.text = secretPhraseVM.revealButtonTitle

		let copyButtonImage = UIImage(named: secretPhraseVM.copyButtonIcon)
		copySeedPhraseButton.setImage(copyButtonImage, for: .normal)

		copySeedPhraseButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 10)

		backgroundColor = .Pino.background
		warningCardView.backgroundColor = .Pino.lightRed

		copySeedPhraseButton.setTitleColor(.Pino.primary, for: .normal)
		copySeedPhraseButton.imageView?.tintColor = .Pino.primary
		warningDescriptionLabel.textColor = .Pino.red

		titleLabel.font = .PinoStyle.mediumTitle2
		warningDescriptionLabel.font = .PinoStyle.mediumCallout

		warningDescriptionLabel.numberOfLines = 0

		warningDescriptionLabel.textAlignment = .center

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical
		seedPhraseStackView.axis = .vertical
		warningStackView.axis = .vertical

		contentStackView.spacing = 24
		titleStackView.spacing = 18
		seedPhraseStackView.spacing = 50
		warningStackView.spacing = 26

		titleStackView.alignment = .leading
		seedPhraseStackView.alignment = .center
		warningStackView.alignment = .center
		warningCardView.layer.cornerRadius = 12
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 25),
			.horizontalEdges
		)
		seedPhraseCollectionView.pin(
			.horizontalEdges(padding: 6)
		)
		titleLabel.pin(
			.horizontalEdges(padding: 16)
		)
		descriptionLabel.pin(
			.horizontalEdges(padding: 16)
		)
		warningCardView.pin(
			.horizontalEdges(padding: 16),
			.bottom(padding: 38)
		)
		warningStackView.pin(
			.horizontalEdges(padding: 22),
			.verticalEdges(padding: 16)
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
	private func revealSeedPhrase() {
		revealTapped()
	}

	// MARK: - Public Methods

	public func showSeedPhrase() {
        if revealLabel.alpha != 0 {
            hapticManager.run(type: .selectionChanged)
        }
		UIView.animate(withDuration: 0.5) {
			self.seedPhraseBlurView.alpha = 0
			self.revealLabel.alpha = 0
			self.seedPhraseCollectionView.showMockCreds = false
		}
	}
}
