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
	private let pageTitle = UILabel()
	private let pageDescription = UILabel()
	private let seedPhraseBox = UIView()
	private let seedPhrasetextView = UITextView()
	private let seedPhrasePasteButton = UIButton()
	private let importButton = PinoButton(style: .deactive, title: "Import")
	private let suggestedSeedPhraseCollectionView = SuggestedSeedPhraseCollectionView()
	private var importSecretPhrase: () -> Void
	private var textViewPlaceHolderText = "Seed Phrase"

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

		suggestedSeedPhraseCollectionView.suggestedSeedPhrase = []
		seedPhrasetextView.inputAccessoryView = suggestedSeedPhraseCollectionView

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

		importButton.addAction(UIAction(handler: { _ in
			self.importSecretPhrase()
		}), for: .touchUpInside)

		seedPhrasePasteButton.addAction(UIAction(handler: { _ in
			self.pasteseedPhrase()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		pageTitle.text = "Import secret phrase"
		pageTitle.textColor = .Pino.label
		pageTitle.font = .PinoStyle.semiboldTitle3

		pageDescription.text = "Typically 12 words separated by single spaces"
		pageDescription.textColor = .Pino.secondaryLabel
		pageDescription.font = .PinoStyle.mediumCallout
		pageDescription.numberOfLines = 0

		seedPhrasetextView.text = textViewPlaceHolderText
		seedPhrasetextView.textColor = .Pino.gray2
		seedPhrasetextView.font = .PinoStyle.mediumBody
		seedPhrasetextView.delegate = self

		seedPhrasePasteButton.setTitle("Paste", for: .normal)
		seedPhrasePasteButton.setTitleColor(.Pino.primary, for: .normal)
		seedPhrasePasteButton.titleLabel?.font = .PinoStyle.semiboldCallout

		seedPhraseBox.layer.cornerRadius = 8
		seedPhraseBox.layer.borderColor = UIColor.Pino.gray5.cgColor
		seedPhraseBox.layer.borderWidth = 1

		contentStackView.axis = .vertical
		contentStackView.spacing = 32

		titleStackView.axis = .vertical
		titleStackView.spacing = 12
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 24),
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
			.fixedHeight(197)
		)
		importButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16),
			.fixedHeight(56)
		)
	}

	private func pasteseedPhrase() {
		let pasteboardString = UIPasteboard.general.string
		if let pasteboardString {
			seedPhrasetextView.text = pasteboardString
			seedPhrasetextView.textColor = .Pino.label
			dissmisskeyBoard()
		}
	}

	@objc
	private func dissmisskeyBoard() {
		seedPhrasetextView.endEditing(true)
	}
}

extension ImportSecretPhraseView: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if seedPhrasetextView.text == textViewPlaceHolderText {
			seedPhrasetextView.text = nil
			seedPhrasetextView.textColor = .Pino.label
		}
		textView.becomeFirstResponder()
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = textViewPlaceHolderText
			textView.textColor = .Pino.gray2
		}
		textView.resignFirstResponder()
	}
}
