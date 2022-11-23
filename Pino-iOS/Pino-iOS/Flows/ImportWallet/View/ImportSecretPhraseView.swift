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
	private let seedPhraseBox = UIView()
	private let seedPhrasetextView = SecretPhraseTextView()
	private let seedPhrasePasteButton = UIButton()
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
		contentStackView.addArrangedSubview(seedPhraseBox)
		titleStackView.addArrangedSubview(pageTitle)
		titleStackView.addArrangedSubview(pageDescription)
		seedPhraseBox.addSubview(seedPhrasetextView)
		seedPhraseBox.addSubview(seedPhrasePasteButton)
		addSubview(contentStackView)
		addSubview(importButton)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

		importButton.addAction(UIAction(handler: { _ in
			self.importSecretPhrase()
		}), for: .touchUpInside)

		seedPhrasePasteButton.addAction(UIAction(handler: { _ in
			self.seedPhrasetextView.pasteText()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		pageTitle.text = "Import secret phrase"

		pageDescription.text = "Typically 12 words separated by single spaces"

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
			.horizontalEdges(padding: 16),
			.top(padding: 16)
		)
		seedPhrasePasteButton.pin(
			.relative(.top, 8, to: seedPhrasetextView, .bottom),
			.bottom(padding: 10),
			.trailing(padding: 10)
		)

		seedPhraseBox.pin(
			.fixedHeight(160)
		)
		importButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16),
			.fixedHeight(56)
		)
	}

	@objc
	private func dissmisskeyBoard() {
		seedPhrasetextView.endEditing(true)
	}
}
