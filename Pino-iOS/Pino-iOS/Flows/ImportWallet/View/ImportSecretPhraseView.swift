//
//  ImportSecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/22/22.
//

import UIKit

class ImportSecretPhraseView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let pageTitle = PinoLabel(style: .title, text: nil)
	private let pageDescription = PinoLabel(style: .description, text: nil)
	private let seedPhraseStackView = UIStackView()
	private let seedPhraseBox = UIView()
	private let seedPhrasePasteButton = UIButton()
	private let errorLabel = UILabel()
	private let errorIcon = UIImageView()
	private var validationPhraseVM: ValidateSecretPhraseViewModel

	// MARK: Public Properties

	public let errorStackView = UIStackView()
	public let importButton = PinoButton(style: .deactive, title: "Import")
	public let seedPhrasetextView = SecretPhraseTextView()

	// MARK: Initializers

	init(validationPharaseVM: ValidateSecretPhraseViewModel) {
		self.validationPhraseVM = validationPharaseVM
		super.init(frame: .zero)
        seedPhrasetextView.seedPhraseMaxCount = validationPharaseVM.maxSeedPhraseCount
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension ImportSecretPhraseView {
	// MARK: UI Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(seedPhraseStackView)
		titleStackView.addArrangedSubview(pageTitle)
		titleStackView.addArrangedSubview(pageDescription)
		seedPhraseStackView.addArrangedSubview(seedPhraseBox)
		seedPhraseStackView.addArrangedSubview(seedPhrasetextView.errorStackView)
		seedPhraseBox.addSubview(seedPhrasetextView)
		seedPhraseBox.addSubview(seedPhrasePasteButton)
		seedPhrasetextView.errorStackView.addArrangedSubview(errorIcon)
		seedPhrasetextView.errorStackView.addArrangedSubview(errorLabel)
		addSubview(contentStackView)
		addSubview(importButton)
		addSubview(seedPhrasetextView.enteredWordsCount)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

		seedPhrasePasteButton.addAction(UIAction(handler: { _ in
			self.seedPhrasetextView.pasteText()
		}), for: .touchUpInside)

		seedPhrasetextView.seedPhraseCountVerified = { isVerified in
			if isVerified {
				self.importButton.style = .active
			} else {
				self.importButton.style = .deactive
			}
		}
	}

	public func showError() {
		seedPhrasetextView.errorStackView.isHidden = false
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		pageTitle.text = "Import secret phrase"
		pageDescription.text = "Typically 12 words separated by single spaces"

		errorLabel.text = "Invalid secret phrase"
		errorLabel.textColor = .Pino.errorRed

		errorLabel.font = .PinoStyle.mediumCallout
		errorLabel.textAlignment = .center

		errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")
		errorIcon.tintColor = .Pino.errorRed

		contentStackView.axis = .horizontal
		seedPhrasetextView.errorStackView.spacing = 5
		seedPhraseStackView.alignment = .leading
		seedPhrasetextView.errorStackView.isHidden = true

		seedPhraseStackView.axis = .vertical
		seedPhraseStackView.spacing = 8

		seedPhrasePasteButton.setTitle("Paste", for: .normal)
		seedPhrasePasteButton.setTitleColor(.Pino.primary, for: .normal)
		seedPhrasePasteButton.titleLabel?.font = .PinoStyle.semiboldCallout

		seedPhraseBox.layer.cornerRadius = 8
		seedPhraseBox.layer.borderColor = UIColor.Pino.gray5.cgColor
		seedPhraseBox.layer.borderWidth = 1

		contentStackView.axis = .vertical
		contentStackView.spacing = 33

		titleStackView.axis = .vertical
		titleStackView.spacing = 18
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 26),
			.horizontalEdges(padding: 16)
		)
		seedPhrasetextView.pin(
			.top(padding: 12),
			.horizontalEdges(padding: 12)
		)
		seedPhrasePasteButton.pin(
			.relative(.top, 8, to: seedPhrasetextView, .bottom),
			.bottom(padding: 6),
			.trailing(padding: 8)
		)
		seedPhraseBox.pin(
			.fixedHeight(160),
			.width
		)
		errorIcon.pin(
			.fixedWidth(16),
			.fixedHeight(16)
		)
		errorLabel.pin(
			.fixedHeight(24)
		)
		importButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		seedPhrasetextView.enteredWordsCount.pin(
			.relative(.top, 10, to: seedPhraseBox, .bottom),
			.trailing(padding: 17)
		)
	}

	@objc
	private func dissmisskeyBoard() {
		seedPhrasetextView.endEditing(true)
	}
}
