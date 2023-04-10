//
//  RevealPrivateKeyView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/13/23.
//

import UIKit

class RevealPrivateKeyView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = UILabel()
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let revealPrivateKeyView = UIView()
	private let revealBlurView = BlurEffectView()
	private let revealStackView = UIStackView()
	private let revealTitleLabel = UILabel()
	private let revealDescriptionLabel = UILabel()
	private let privateKeyStackView = UIStackView()
	private let privateKeyView = UIView()
	private let privateKeyLabel = PinoLabel(style: .description, text: nil)
	private let copyPrivateKeyButton = UIButton()
	private let continueButton = PinoButton(style: .active)
	private var revealPrivateKeyVM: RevealPrivateKeyViewModel
	private let copyPrivateKeyTapped: () -> Void
	private let doneButtonTapped: () -> Void
	private let revealTapped: () -> Void

	// MARK: Initializers

	init(
		revealPrivateKeyVM: RevealPrivateKeyViewModel,
		copyPrivateKeyTapped: @escaping () -> Void,
		doneButtonTapped: @escaping () -> Void,
		revealTapped: @escaping () -> Void
	) {
		self.revealPrivateKeyVM = revealPrivateKeyVM
		self.copyPrivateKeyTapped = copyPrivateKeyTapped
		self.doneButtonTapped = doneButtonTapped
		self.revealTapped = revealTapped
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(privateKeyStackView)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		revealPrivateKeyView.addSubview(privateKeyView)
		revealPrivateKeyView.addSubview(revealBlurView)
		revealPrivateKeyView.addSubview(revealStackView)
		revealStackView.addArrangedSubview(revealTitleLabel)
		revealStackView.addArrangedSubview(revealDescriptionLabel)
		privateKeyStackView.addArrangedSubview(revealPrivateKeyView)
		privateKeyStackView.addArrangedSubview(copyPrivateKeyButton)
		privateKeyView.addSubview(privateKeyLabel)
		addSubview(contentStackView)
		addSubview(continueButton)

		let revealTapGesture = UITapGestureRecognizer(target: self, action: #selector(revealPrivateKey))
		revealPrivateKeyView.addGestureRecognizer(revealTapGesture)

		copyPrivateKeyButton.addAction(UIAction(handler: { _ in
			self.copyPrivateKeyTapped()
		}), for: .touchUpInside)

		continueButton.addAction(UIAction(handler: { _ in
			self.doneButtonTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		titleLabel.text = revealPrivateKeyVM.pageTitle
		descriptionLabel.text = revealPrivateKeyVM.pageDescription
		revealTitleLabel.text = revealPrivateKeyVM.revealTitle
		revealDescriptionLabel.text = revealPrivateKeyVM.revealDescription
		privateKeyLabel.text = revealPrivateKeyVM.lockedPrivateKey
		copyPrivateKeyButton.setTitle(revealPrivateKeyVM.copyButtonTitle, for: .normal)
		continueButton.title = "Done"

		let shareButtonImage = UIImage(systemName: revealPrivateKeyVM.copyButtonImage)
		copyPrivateKeyButton.setImage(shareButtonImage, for: .normal)

		backgroundColor = .Pino.background
		privateKeyView.backgroundColor = .Pino.gray4

		titleLabel.textColor = .Pino.red
		descriptionLabel.textColor = .Pino.label
		revealTitleLabel.textColor = .Pino.label
		revealDescriptionLabel.textColor = .Pino.label
		privateKeyLabel.textColor = .Pino.label
		copyPrivateKeyButton.setTitleColor(.Pino.primary, for: .normal)
		copyPrivateKeyButton.tintColor = .Pino.primary

		titleLabel.font = .PinoStyle.semiboldBody
		descriptionLabel.font = .PinoStyle.mediumSubheadline
		revealTitleLabel.font = .PinoStyle.semiboldBody
		revealDescriptionLabel.font = .PinoStyle.mediumSubheadline
		privateKeyLabel.font = .PinoStyle.mediumSubheadline

		copyPrivateKeyButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 10)

		descriptionLabel.numberOfLines = 0
		privateKeyLabel.numberOfLines = 0
		descriptionLabel.textAlignment = .center

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical
		privateKeyStackView.axis = .vertical
		revealStackView.axis = .vertical

		contentStackView.spacing = 16
		titleStackView.spacing = 24
		privateKeyStackView.spacing = 36
		revealStackView.spacing = 11

		titleStackView.alignment = .center
		revealStackView.alignment = .center
		contentStackView.alignment = .center

		privateKeyView.layer.cornerRadius = 12
		privateKeyView.layer.borderColor = UIColor.Pino.gray3.cgColor
		privateKeyView.layer.borderWidth = 1
		privateKeyView.backgroundColor = .Pino.gray5

		privateKeyLabel.alpha = 0.4
		copyPrivateKeyButton.alpha = 0
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 34),
			.horizontalEdges
		)
		titleStackView.pin(
			.horizontalEdges(padding: 16)
		)
		continueButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		revealBlurView.pin(
			.allEdges()
		)
		revealStackView.pin(
			.centerX,
			.centerY
		)
		privateKeyLabel.pin(
			.horizontalEdges(padding: 16),
			.verticalEdges(padding: 24)
		)
		privateKeyView.pin(
			.allEdges(padding: 16)
		)
	}

	public func showPrivateKey() {
		UIView.animate(withDuration: 0.5) {
			self.privateKeyLabel.text = self.revealPrivateKeyVM.privateKey
			self.privateKeyLabel.alpha = 0.9
			self.revealBlurView.alpha = 0
			self.revealStackView.alpha = 0
			self.copyPrivateKeyButton.alpha = 1
		}
	}

	@objc
	private func revealPrivateKey() {
		revealTapped()
	}
}
