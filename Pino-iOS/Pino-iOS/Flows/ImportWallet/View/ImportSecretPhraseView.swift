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
	private let seedPhrasetextView = SecretPhraseTextView()
	private let seedPhrasePasteButton = UIButton()
	private let errorStackView = UIStackView()
	private let errorLabel = UILabel()
	private let errorIcon = UIImageView()
	private let importButton = PinoButton(style: .deactive, title: "Import")
	private var importSecretPhrase: () -> Void

	// MARK: Initializers

	init(importSecretPhrase: @escaping (() -> Void)) {
		self.importSecretPhrase = importSecretPhrase
		super.init(frame: .zero)

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
		seedPhraseStackView.addArrangedSubview(errorStackView)
		seedPhraseBox.addSubview(seedPhrasetextView)
		seedPhraseBox.addSubview(seedPhrasePasteButton)
		errorStackView.addArrangedSubview(errorIcon)
		errorStackView.addArrangedSubview(errorLabel)
		addSubview(contentStackView)
		addSubview(importButton)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

		importButton.addAction(UIAction(handler: { _ in
			self.importSecretPhrase()
		}), for: .touchUpInside)

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

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		pageTitle.text = "Import secret phrase"
		pageDescription.text = "Typically 12 words separated by single spaces"

		errorLabel.text = "Invalid Secret Phrase"
		errorLabel.textColor = .Pino.errorRed

		errorLabel.font = .PinoStyle.mediumCallout
		errorLabel.textAlignment = .center

		errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")
		errorIcon.tintColor = .Pino.errorRed

		contentStackView.axis = .horizontal
		errorStackView.spacing = 5
		seedPhraseStackView.alignment = .leading
		errorStackView.isHidden = true

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
	}

	@objc
	private func dissmisskeyBoard() {
		seedPhrasetextView.endEditing(true)
	}
}
